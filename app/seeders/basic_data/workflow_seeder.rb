#-- encoding: UTF-8


module BasicData
  class WorkflowSeeder < Seeder
    def seed_data!
      colors = Color.all
      colors = colors.map { |c| { c.name => c.id } }.reduce({}, :merge)

      if WorkPackage.where(type_id: nil).any? || Journal::WorkPackageJournal.where(type_id: nil).any?
        # Fixes work packages that do not have a type yet. They receive the standard type.
        #
        # This can happen when an existing database, having timelines planning elements,
        # gets migrated. During the migration, the existing planning elements are converted
        # to work_packages. Because the existence of a standard type cannot be guaranteed
        # during the migration, such work packages receive a type_id of nil.
        #
        # Because all work packages that do not have a type yet should always have had one
        # (from todays standpoint). The assignment is done covertedly.

        WorkPackage.transaction do
          green_color = colors[I18n.t(:default_color_green_light)]
          standard_type = Type.find_or_create_by(is_standard: true,
                                                 name: 'none',
                                                 position: 0,
                                                 color_id: green_color,
                                                 is_default: true,
                                                 is_in_roadmap: true,
                                                 is_milestone: false)

          [WorkPackage, Journal::WorkPackageJournal].each do |klass|
            klass.where(type_id: nil).update_all(type_id: standard_type.id)
          end
        end
      end

      if Type.where(is_standard: false).any? || Status.any? || Workflow.any?
        puts '   *** Skipping types, statuses and workflows as there are already some configured'
      elsif Role.where(name: I18n.t(:default_role_member)).empty? ||
            Role.where(name: I18n.t(:default_role_project_admin)).empty?

        puts '   *** Skipping types, statuses and workflows as the required roles do not exist'
      else
        member = Role.where(name: I18n.t(:default_role_member)).first
        manager = Role.where(name: I18n.t(:default_role_project_admin)).first

        puts '   ↳ Types'
        type_seeder_class.new.seed!

        puts '   ↳ Statuses'
        status_seeder_class.new.seed!

        # Workflow - Each type has its own workflow
        workflows.each do |type_id, statuses_for_type|
          statuses_for_type.each do |old_status|
            statuses_for_type.each do |new_status|
              [manager.id, member.id].each do |role_id|
                Workflow.create type_id: type_id,
                                role_id: role_id,
                                old_status_id: old_status.id,
                                new_status_id: new_status.id
              end
            end
          end
        end
      end
    end

    def workflows
      raise NotImplementedError
    end

    def type_seeder_class
      raise NotImplementedError
    end

    def status_seeder_class
      raise NotImplementedError
    end
  end
end