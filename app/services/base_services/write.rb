#-- encoding: UTF-8



module BaseServices
  class Write < BaseContracted
    protected

    def persist(service_result)
      service_result = super(service_result)

      unless service_result.result.save
        service_result.errors = service_result.result.errors
        service_result.success = false
      end

      service_result
    end

    # Validations are already handled in the SetAttributesService
    # and thus we do not have to validate again.
    def validate_contract(service_result)
      service_result
    end

    def before_perform(params, _service_result)
      set_attributes(params)
    end

    def set_attributes(params)
      attributes_service_class
        .new(user: user,
             model: instance(params),
             contract_class: contract_class,
             contract_options: contract_options)
        .call(set_attributes_params(params))
    end

    def attributes_service_class
      "#{namespace}::SetAttributesService".constantize
    end

    def instance(_params)
      raise NotImplementedError
    end

    def default_contract_class
      raise NotImplementedError
    end

    def instance_class
      namespace.singularize.constantize
    end

    def set_attributes_params(params)
      params
    end
  end
end
