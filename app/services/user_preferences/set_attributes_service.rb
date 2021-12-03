#-- encoding: UTF-8

module UserPreferences
  class SetAttributesService < ::BaseServices::SetAttributes
    def set_attributes(params)
      set_boolean_value(:hide_mail, params.delete(:hide_mail)) if params.key?(:hide_mail)

      params.each do |k, v|
        model[k] = v if model.supported_settings_method?(k)
      end
    end

    private

    def set_boolean_value(key, value)
      model[key] = ActiveRecord::Type::Boolean.new.cast(value)
    end
  end
end
