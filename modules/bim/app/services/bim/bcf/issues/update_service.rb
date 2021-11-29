#-- encoding: UTF-8



module Bim::Bcf
  module Issues
    class UpdateService < ::BaseServices::Update
      private

      def before_perform(params, service_result)
        wp_call = ::WorkPackages::UpdateService
          .new(model: model.work_package,
               user: user,
               contract_class: ::WorkPackages::UpdateContract)
          .call(**params)

        if wp_call.success?
          issue_params = params.slice(*Bim::Bcf::Issue::SETTABLE_ATTRIBUTES)

          super(issue_params, service_result)
        else
          wp_call
        end
      end
    end
  end
end
