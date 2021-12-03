#-- encoding: UTF-8

##
# Adds and removes modules from a project
#
module Projects
  class EnabledModulesService < ::BaseServices::BaseContracted
    def initialize(user:, model:, contract_class: ::Projects::EnabledModulesContract)
      super(user: user, contract_class: contract_class)
      self.model = model
    end

    private

    def before_perform(params, _service_result)
      model.enabled_module_names = params[:enabled_modules]
      super
    end

    def persist(call)
      # Nothing to do any more
      call
    end

    def after_perform(call)
      super.tap do
        # Ensure the project is touched to update its cache key
        model.touch
      end
    end
  end
end
