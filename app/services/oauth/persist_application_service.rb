#-- encoding: UTF-8



module OAuth
  class PersistApplicationService
    include Contracted

    attr_reader :application, :current_user

    def initialize(model, user:)
      @application = model
      @current_user = user

      self.contract_class = OAuth::ApplicationContract
    end

    def call(attributes)
      set_defaults
      application.attributes = attributes

      result, errors = validate_and_save(application, current_user)
      ServiceResult.new success: result, errors: errors, result: application
    end

    def set_defaults
      return if application.owner_id

      application.owner = current_user
      application.owner_type = 'User'
    end
  end
end
