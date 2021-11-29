#-- encoding: UTF-8


module Bim
  module BasicData
    class RoleSeeder < ::BasicData::RoleSeeder
      def member
        super.tap do |role_data|
          role_data[:permissions] += %i[view_linked_issues manage_bcf delete_work_packages manage_ifc_models view_ifc_models]
        end
      end

      def reader
        super.tap do |role_data|
          role_data[:permissions] += %i[view_linked_issues]
        end
      end

      def non_member
        super.tap do |role_data|
          role_data[:permissions] += %i[view_linked_issues view_ifc_models]
        end
      end

      def anonymous
        super.tap do |role_data|
          role_data[:permissions] += %i[view_linked_issues]
        end
      end
    end
  end
end
