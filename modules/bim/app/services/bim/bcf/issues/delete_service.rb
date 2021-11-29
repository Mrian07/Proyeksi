#-- encoding: UTF-8



module Bim::Bcf
  module Issues
    class DeleteService < ::BaseServices::Delete
      private

      def after_validate(params, contract_call)
        wp_call = work_package_delete_call(params)

        if wp_call.success?
          contract_call
        else
          wp_call
        end
      end

      def work_package_delete_call(params)
        associated_wp = WorkPackage.find(model.work_package_id)
        # Load the project association as AR fails do do so once the work package
        # is destroyed.
        model.project

        ::WorkPackages::DeleteService
          .new(user: user,
               model: associated_wp.reload)
          .call(params)
      end
    end
  end
end
