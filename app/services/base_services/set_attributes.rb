#-- encoding: UTF-8

module BaseServices
  class SetAttributes < BaseCallable
    include Contracted

    def initialize(user:, model:, contract_class:, contract_options: {})
      self.user = user
      self.model = prepare_model(model)

      self.contract_class = contract_class
      self.contract_options = contract_options
    end

    def perform(params = nil)
      set_attributes(params || {})

      validate_and_result
    end

    private

    attr_accessor :user,
                  :model,
                  :contract_class

    def set_attributes(params)
      model.attributes = params

      set_default_attributes(params) if model.new_record?
    end

    def set_default_attributes(_params)
      # nothing to do for now but a subclass may
    end

    def validate_and_result
      success, errors = validate(model, user, options: contract_options)

      ServiceResult.new(success: success,
                        errors: errors,
                        result: model)
    end

    def prepare_model(model)
      model.extend(ProyeksiApp::ChangedBySystem)
      model
    end
  end
end
