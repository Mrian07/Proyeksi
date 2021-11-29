#-- encoding: UTF-8



module Bim::Bcf
  module Issues
    class CreateService < ::BaseServices::Create
      private

      def before_perform(params, service_result)
        wp_call = get_work_package params
        return wp_call if wp_call.failure?

        super issue_params(work_package: wp_call.result, params: params), service_result
      end

      def issue_params(work_package:, params:)
        { work_package: work_package }
          .merge(params.slice(*Bim::Bcf::Issue::SETTABLE_ATTRIBUTES))
      end

      def get_work_package(params)
        wp_links = remove_work_package_links! Array(params[:reference_links])

        if !wp_links.empty?
          params.delete :reference_links

          use_work_package links: wp_links, params: params
        else
          create_work_package params
        end
      end

      def use_work_package(links:, params:)
        work_package = WorkPackage.find_by(id: work_package_id_from_links(links))
        return work_package_not_found_result if work_package.nil?

        ::WorkPackages::UpdateService
          .new(user: user, model: work_package)
          .call(**params)
      end

      def create_work_package(params)
        ::WorkPackages::CreateService
          .new(user: user)
          .call(**params)
      end

      def work_package_id_from_links(links)
        links
          .take(1)
          .map { |link| link.split("/").last.to_i }
          .first
      end

      def remove_work_package_links!(links)
        path = api_path_helper.work_package("")
        wp_links = links.select { |link| link.include? path }

        links.delete_if { |link| wp_links.include? link }

        wp_links
      end

      def work_package_not_found_result
        ServiceResult.new(errors: Bim::Bcf::Issue.new.errors).tap do |r|
          r.errors.add :work_package, :does_not_exist
        end
      end

      def api_path_helper
        ::API::V3::Utilities::PathHelper::ApiV3Path
      end
    end
  end
end
