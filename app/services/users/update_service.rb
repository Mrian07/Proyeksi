#-- encoding: UTF-8

module Users
  class UpdateService < ::BaseServices::Update
    include ::HookHelper

    protected

    def before_perform(params, _service_result)
      call_hook :service_update_user_before_save,
                params: params,
                user: model

      super
    end

    def persist(service_result)
      service_result = super(service_result)

      if service_result.success?
        service_result.success = model.pref.save
      end

      service_result
    end
  end
end
