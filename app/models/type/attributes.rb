#-- encoding: UTF-8



module Type::Attributes
  extend ActiveSupport::Concern

  EXCLUDED = %w[_type
                _dependencies
                attribute_groups
                links parent_id
                parent
                description
                schedule_manually
                derived_start_date
                derived_due_date
                derived_estimated_time].freeze

  included do
    # Allow plugins to define constraints
    # that disable a given attribute for this type.
    mattr_accessor :attribute_constraints do
      {}
    end
  end

  class_methods do
    ##
    # Add a constraint for the given attribute
    def add_constraint(attribute, callable)
      unless callable.respond_to?(:call)
        raise ArgumentError, "Expecting callable object for constraint #{key}"
      end

      attribute_constraints[attribute.to_sym] = callable
    end

    ##
    # Provides a map of all work package form attributes as seen when creating
    # or updating a work package. Through this map it can be checked whether or
    # not an attribute is required.
    #
    # E.g.
    #
    #   ::Type.work_package_form_attributes['author'][:required] # => true
    #
    # @return [Hash{String => Hash}] Map from attribute names to options.
    def all_work_package_form_attributes(merge_date: false)
      wp_cf_cache_parts = RequestStore.fetch(:wp_cf_max_updated_at_and_count) do
        WorkPackageCustomField.pluck(Arel.sql('max(updated_at), count(id)')).flatten
      end

      ProyeksiApp::Cache.fetch('all_work_package_form_attributes',
                               *wp_cf_cache_parts,
                               merge_date) do
        calculate_all_work_package_form_attributes(merge_date)
      end
    end

    def translated_work_package_form_attributes(merge_date: false)
      all_work_package_form_attributes(merge_date: merge_date)
        .each_with_object({}) do |(k, v), hash|
        hash[k] = translated_attribute_name(k, v)
      end
    end

    def translated_attribute_name(name, attr)
      if attr[:name_source]
        attr[:name_source].call
      else
        attr[:display_name] || attr_translate(name)
      end
    end

    private

    def calculate_all_work_package_form_attributes(merge_date)
      attributes = calculate_default_work_package_form_attributes

      # within the form date is shown as a single entry including start and due
      if merge_date
        merge_date_for_form_attributes(attributes)
      end

      add_custom_fields_to_form_attributes(attributes)

      attributes
    end

    def calculate_default_work_package_form_attributes
      representable_config = API::V3::WorkPackages::Schema::WorkPackageSchemaRepresenter
                             .representable_attrs

      # For reasons beyond me, Representable::Config contains the definitions
      #  * nested in [:definitions] in some envs, e.g. development
      #  * directly in other envs, e.g. test
      definitions = representable_config.key?(:definitions) ? representable_config[:definitions] : representable_config

      definitions.keys
                 .reject { |key| skipped_attribute?(key, definitions[key]) }
                 .map { |key| [key, JSON::parse(definitions[key].to_json)] }.to_h
    end

    def skipped_attribute?(key, definition)
      # We always want to include the priority even if its required
      return false if key == 'priority'

      EXCLUDED.include?(key) || definition[:required]
    end

    def merge_date_for_form_attributes(attributes)
      attributes['date'] = { required: false, has_default: false }
      attributes.delete 'due_date'
      attributes.delete 'start_date'
    end

    def add_custom_fields_to_form_attributes(attributes)
      WorkPackageCustomField.includes(:custom_options).all.each do |field|
        attributes["custom_field_#{field.id}"] = {
          required: field.is_required,
          has_default: field.default_value.present?,
          is_cf: true,
          display_name: field.name
        }
      end
    end

    def attr_i18n_key(name)
      if name == 'percentage_done'
        'done_ratio'
      else
        name
      end
    end

    def attr_translate(name)
      if name == 'date'
        I18n.t('label_date')
      else
        key = attr_i18n_key(name)
        I18n.t("activerecord.attributes.work_package.#{key}", fallback: false, default: '')
          .presence || I18n.t("attributes.#{key}")
      end
    end
  end

  ##
  # Get all applicable work package attributes
  def work_package_attributes(merge_date: true)
    all_attributes = self.class.all_work_package_form_attributes(merge_date: merge_date)

    # Reject those attributes that are not available for this type.
    all_attributes.select { |key, _| passes_attribute_constraint? key }
  end

  ##
  # Verify that the given attribute is applicable
  # in this type instance.
  # If a project context is given, that context is passed
  # to the constraint validator.
  def passes_attribute_constraint?(attribute, project: nil)
    # Check custom field constraints
    if CustomField.custom_field_attribute?(attribute) && !project.nil?
      return custom_field_in_project?(attribute, project)
    end

    # Check other constraints (none in the core, but costs/backlogs adds constraints)
    constraint = attribute_constraints[attribute.to_sym]
    constraint.nil? || constraint.call(self, project: project)
  end

  ##
  # Returns the active custom_field_attributes
  def active_custom_field_attributes
    custom_field_ids.map { |id| "custom_field_#{id}" }
  end

  ##
  # Returns whether the custom field is active in the given project.
  def custom_field_in_project?(attribute, project)
    project
      .all_work_package_custom_fields.pluck(:id)
      .map { |id| "custom_field_#{id}" }
      .include? attribute
  end
end
