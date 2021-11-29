#-- encoding: UTF-8



module Projects::Copy
  class WorkPackagesDependentService < Dependency
    def self.human_name
      I18n.t(:label_work_package_plural)
    end

    def source_count
      source.work_packages.count
    end

    protected

    def copy_dependency(params:)
      # Stores the source work_package id as a key and the copied work package ID as the
      # value.  Used to map the two together for work_package relations.
      work_packages_map = {}

      # Get work_packages sorted by their depth in the hierarchy tree
      # so that parents get copied before their children.
      to_copy = source
        .work_packages
        .includes(:custom_values, :version, :assigned_to, :responsible)
        .order_by_ancestors('asc')
        .order('id ASC')

      user_cf_ids = WorkPackageCustomField.where(field_format: 'user').pluck(:id)

      to_copy.each do |wp|
        parent_id = work_packages_map[wp.parent_id] || wp.parent_id

        new_wp = copy_work_package(wp, parent_id, user_cf_ids)

        work_packages_map[wp.id] = new_wp.id if new_wp
      end

      # Relations and attachments after in case work_packages related each other
      to_copy.each do |wp|
        new_wp_id = work_packages_map[wp.id]
        next unless new_wp_id

        copy_relations(wp, new_wp_id, work_packages_map)
      end

      state.work_package_id_lookup = work_packages_map
    end

    def copy_work_package(source_work_package, parent_id, user_cf_ids)
      overrides = copy_work_package_attribute_overrides(source_work_package, parent_id, user_cf_ids)

      service_call = WorkPackages::CopyService
        .new(user: user,
             work_package: source_work_package,
             contract_class: WorkPackages::CopyProjectContract)
        .call(**overrides)

      if service_call.success?
        service_call.result
      else
        add_error!(source_work_package, service_call.errors)
        error = service_call.message
        Rails.logger.warn do
          "Project#copy_work_packages: work package ##{source_work_package.id} could not be copied: #{error}"
        end

        nil
      end
    end

    def copy_relations(wp, new_wp_id, work_packages_map)
      wp.relations_to.non_hierarchy.direct.each do |source_relation|
        new_relation = Relation.new
        new_relation.attributes = source_relation.attributes.dup.except('id', 'from_id', 'to_id', 'relation_type')
        new_relation.to_id = work_packages_map[source_relation.to_id]
        if new_relation.to_id.nil? && Setting.cross_project_work_package_relations?
          new_relation.to_id = source_relation.to_id
        end
        new_relation.from_id = new_wp_id
        new_relation.save
      end

      wp.relations_from.non_hierarchy.direct.each do |source_relation|
        new_relation = Relation.new
        new_relation.attributes = source_relation.attributes.dup.except('id', 'from_id', 'to_id', 'relation_type')
        new_relation.from_id = work_packages_map[source_relation.from_id]
        if new_relation.from_id.nil? && Setting.cross_project_work_package_relations?
          new_relation.from_id = source_relation.from_id
        end
        new_relation.to_id = new_wp_id
        new_relation.save
      end
    end

    def copy_work_package_attribute_overrides(source_work_package, parent_id, user_cf_ids)
      custom_value_attributes = source_work_package.custom_value_attributes.map do |id, value|
        if user_cf_ids.include?(id) && !target.users.detect { |u| u.id.to_s == value }
          [id, nil]
        else
          [id, value]
        end
      end.to_h

      {
        project: target,
        parent_id: parent_id,
        version_id: work_package_version_id(source_work_package),
        assigned_to_id: work_package_assigned_to_id(source_work_package),
        responsible_id: work_package_responsible_id(source_work_package),
        custom_field_values: custom_value_attributes,
        # We fetch the value from the global registry to persist it in the job which
        # will trigger a delayed job for potentially sending the journal notifications.
        send_notifications: ActionMailer::Base.perform_deliveries
      }
    end

    def work_package_version_id(source_work_package)
      return unless source_work_package.version_id

      state.version_id_lookup[source_work_package.version_id]
    end

    def work_package_assigned_to_id(source_work_package)
      possible_principal_id(source_work_package.assigned_to_id,
                            source_work_package.project)
    end

    def work_package_responsible_id(source_work_package)
      possible_principal_id(source_work_package.responsible_id,
                            source_work_package.project)
    end

    def possible_principal_id(principal_id, project)
      return unless principal_id

      @principals ||= Principal.possible_assignee(project).pluck(:id).to_set
      principal_id if @principals.include?(principal_id)
    end
  end
end