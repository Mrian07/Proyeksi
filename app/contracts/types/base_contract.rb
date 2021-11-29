#-- encoding: UTF-8



require 'model_contract'

module Types
  class BaseContract < ::ModelContract
    def self.model
      Type
    end

    attribute :name
    attribute :is_in_roadmap
    attribute :is_milestone
    attribute :is_default
    attribute :color_id
    attribute :project_ids
    attribute :description
    attribute :attribute_groups

    validate :validate_current_user_is_admin
    validate :validate_attribute_group_names
    validate :validate_attribute_groups

    def validate_current_user_is_admin
      unless user.admin?
        errors.add(:base, :error_unauthorized)
      end
    end

    def validate_attribute_group_names
      return unless model.attribute_groups_changed?

      seen = Set.new
      model.attribute_groups.each do |group|
        errors.add(:attribute_groups, :group_without_name) unless group.key.present?
        errors.add(:attribute_groups, :duplicate_group, group: group.key) if seen.add?(group.key).nil?
      end
    end

    def validate_attribute_groups
      return unless model.attribute_groups_changed?

      model.attribute_groups_objects.each do |group|
        if group.is_a?(Type::QueryGroup)
          validate_query_group(group)
        else
          validate_attribute_group(group)
        end
      end
    end

    def validate_query_group(group)
      query = group.query

      contract_class = query.persisted? ? Queries::UpdateContract : Queries::CreateContract
      contract = contract_class.new(query, user)

      unless contract.validate
        errors.add(:attribute_groups, :query_invalid, group: group.key, details: contract.errors.full_messages.join)
      end
    end

    def validate_attribute_group(group)
      valid_attributes = model.work_package_attributes.keys

      group.attributes.each do |key|
        if key.is_a?(String) && valid_attributes.exclude?(key)
          errors.add(
            :attribute_groups,
            I18n.t('activerecord.errors.models.type.attributes.attribute_groups.attribute_unknown_name',
                   attribute: key)
          )
        end
      end
    end
  end
end
