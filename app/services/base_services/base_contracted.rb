#-- encoding: UTF-8



module BaseServices
  class BaseContracted < BaseCallable
    include Contracted
    include Shared::ServiceContext

    attr_reader :user

    def initialize(user:, contract_class: nil, contract_options: {})
      super()
      @user = user
      self.contract_class = contract_class || default_contract_class
      self.contract_options = contract_options
    end

    protected

    ##
    # Reference to a resource that we're servicing
    attr_accessor :model

    ##
    # Determine the type of context
    # this service is running in
    # e.g., within a resource lock or just executing as the given user
    def service_context(&block)
      in_context(model, true, &block)
    end

    def perform(params = nil)
      service_context do
        service_call = validate_params(params)
        service_call = before_perform(params, service_call) if service_call.success?
        service_call = validate_contract(service_call) if service_call.success?
        service_call = after_validate(params, service_call) if service_call.success?
        service_call = persist(service_call) if service_call.success?
        service_call = after_perform(service_call) if service_call.success?

        service_call
      end
    end

    def validate_params(_params)
      ServiceResult.new(success: true, result: model)
    end

    def before_perform(*)
      ServiceResult.new(success: true, result: model)
    end

    def after_validate(_params, contract_call)
      contract_call
    end

    def validate_contract(call)
      success, errors = validate(model, user, options: contract_options)

      unless success
        call.success = false
        call.errors = errors
      end

      call
    end

    def after_perform(call)
      # nothing for now but subclasses can override
      call
    end

    alias_method :after_save, :after_perform

    def persist(call)
      # nothing for now but subclasses can override
      call
    end

    def default_contract_class
      raise NotImplementedError
    end

    def namespace
      self.class.name.deconstantize.pluralize
    end
  end
end
