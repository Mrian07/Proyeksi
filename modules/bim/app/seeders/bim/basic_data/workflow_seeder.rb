#-- encoding: UTF-8


module Bim
  module BasicData
    class WorkflowSeeder < ::BasicData::WorkflowSeeder
      def workflows
        types = Type.all
        types = types.map { |t| { t.name => t.id } }.reduce({}, :merge)

        new              = Status.find_by(name: I18n.t(:default_status_new))
        in_progress      = Status.find_by(name: I18n.t(:default_status_in_progress))
        closed           = Status.find_by(name: I18n.t(:default_status_closed))
        resolved         = Status.find_by(name: I18n.t('seeders.bim.default_status_resolved'))

        {
          types[I18n.t(:default_type_task)] => [new, in_progress, closed],
          types[I18n.t(:default_type_milestone)] => [new, in_progress, closed],
          types[I18n.t(:default_type_phase)] => [new, in_progress, closed],
          types[I18n.t('seeders.bim.default_type_clash')] => [new, in_progress, resolved, closed],
          types[I18n.t('seeders.bim.default_type_issue')] => [new, in_progress, resolved, closed],
          types[I18n.t('seeders.bim.default_type_remark')] => [new, in_progress, resolved, closed],
          types[I18n.t('seeders.bim.default_type_request')] => [new, in_progress, resolved, closed]
        }
      end

      def type_seeder_class
        ::Bim::BasicData::TypeSeeder
      end

      def status_seeder_class
        ::Bim::BasicData::StatusSeeder
      end
    end
  end
end
