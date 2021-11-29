#-- encoding: UTF-8



module WorkPackages
  module Bulk
    class UpdateService
      include ::Shared::ServiceContext
      include ::HookHelper

      attr_accessor :user, :work_packages, :permitted_params

      def initialize(user:, work_packages:)
        self.user = user
        self.work_packages = work_packages
      end

      def call(params:)
        self.permitted_params = PermittedParams.new(params, user)
        in_user_context(params[:send_notification] == '1') do
          bulk_update(params)
        end
      end

      private

      def bulk_update(params)
        saved = []
        errors = {}

        work_packages.each do |work_package|
          # As updating one work package might have already saved another one,
          # e.g. by changing the start/due date or the version
          # we need to reload the work packages to avoid running into stale object errors.
          work_package.reload

          work_package.add_journal(user, params[:notes])

          # filter parameters by whitelist and add defaults
          attributes = parse_params_for_bulk_work_package_attributes params, work_package.project

          call_hook(:controller_work_packages_bulk_edit_before_save, params: params, work_package: work_package)

          service_call = WorkPackages::UpdateService
                         .new(user: user, model: work_package)
                         .call(**attributes.symbolize_keys)

          if service_call.success?
            saved << work_package.id
          else
            errors[work_package.id] = service_call.errors.full_messages
          end
        end

        ServiceResult.new success: errors.empty?, result: saved, errors: errors
      end

      # TODO: move params transformation out of here as this is not the responsibility of a service
      def parse_params_for_bulk_work_package_attributes(params, project)
        return {} unless params.has_key? :work_package

        safe_params = permitted_params.update_work_package project: project
        attributes = safe_params.reject { |_k, v| v.blank? }
        attributes.keys.each do |k|
          attributes[k] = '' if attributes[k] == 'none'
        end
        attributes[:custom_field_values].reject! { |_k, v| v.blank? } if attributes[:custom_field_values]
        attributes.delete :custom_field_values if not attributes.has_key?(:custom_field_values) or attributes[:custom_field_values].empty?
        attributes.to_h
      end
    end
  end
end
