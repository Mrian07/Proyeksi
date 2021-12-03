#-- encoding: UTF-8

module CustomFields
  class BaseContract < ::ModelContract
    include RequiresAdminGuard

    attribute :editable
    attribute :type
    attribute :field_format
    attribute :is_filter
    attribute :is_for_all
    attribute :is_required
    attribute :max_length
    attribute :min_length
    attribute :name
    attribute :possible_values
    attribute :regexp
    attribute :searchable
    attribute :visible
    attribute :default_value
    attribute :possible_values
    attribute :multi_value
    attribute :content_right_to_left
  end
end
