#-- encoding: UTF-8

module Projects
  class SetAttributesService < ::BaseServices::SetAttributes
    private

    def set_attributes(params)
      attributes = params.dup
      status_attributes = attributes.delete(:status) || {}

      ret = super(attributes)

      update_status(status_attributes)

      ret
    end

    def set_default_attributes(attributes)
      attribute_keys = attributes.keys.map(&:to_s)

      set_default_public(attribute_keys.include?('public'))
      set_default_module_names(attribute_keys.include?('enabled_module_names'))
      set_default_types(attribute_keys.include?('types') || attribute_keys.include?('type_ids'))
    end

    def set_default_public(provided)
      model.public = Setting.default_projects_public? unless provided
    end

    def set_default_module_names(provided)
      model.enabled_module_names = Setting.default_projects_modules if !provided && model.enabled_module_names.empty?
    end

    def set_default_types(provided)
      model.types = ::Type.default if !provided && model.types.empty?
    end

    def update_status(attributes)
      with_hack_around_faulty_enum(attributes) do |safe_attributes|
        if model.status
          model.status.attributes = safe_attributes
        else
          model.build_status(safe_attributes)
        end
      end
    end

    # Hack around ArgumentError on faulty enum values
    # https://github.com/rails/rails/issues/13971
    def with_hack_around_faulty_enum(attributes)
      faulty_code = if faulty_code?(attributes)
                      attributes.delete(:code)
                    end

      yield(attributes)

      if faulty_code
        # set an arbitrary status code first to get rails internal into correct state
        model.status.code = first_not_set_code
        # hack into rails internals to set faulty code
        code_attributes = model.status.instance_variable_get(:@attributes)['code']
        code_attributes.instance_variable_set(:@value_before_type_cast, faulty_code)
        code_attributes.instance_variable_set(:@value, faulty_code)
      end
    end

    def faulty_code?(attributes)
      attributes && attributes[:code] && !Projects::Status.codes.keys.include?(attributes[:code].to_s)
    end

    def first_not_set_code
      (Projects::Status.codes.keys - [model.status.code]).first
    end
  end
end
