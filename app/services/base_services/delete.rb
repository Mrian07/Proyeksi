

module BaseServices
  class Delete < BaseContracted
    def initialize(user:, model:, contract_class: nil, contract_options: {})
      self.model = model
      super(user: user, contract_class: contract_class, contract_options: contract_options)
    end

    def persist(service_result)
      service_result = super(service_result)

      unless destroy(service_result.result)
        service_result.errors = service_result.result.errors
        service_result.success = false
      end

      service_result
    end

    def destroy(object)
      object.destroy
    end

    protected

    def default_contract_class
      "#{namespace}::DeleteContract".constantize
    end
  end
end
