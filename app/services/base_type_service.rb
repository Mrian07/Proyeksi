#-- encoding: UTF-8

class BaseTypeService
  include Shared::BlockService
  include Contracted

  attr_accessor :contract_class, :type, :user

  def initialize(type, user)
    self.type = type
    self.user = user
    self.contract_class = ::Types::BaseContract
  end

  def call(params, options, &block)
    result = update(params, options)

    block_with_result(result, &block)
  end

  private

  def update(params, options)
    success = false
    errors = type.errors

    Type.transaction do
      set_scalar_params(params)

      # Only set attribute groups when it exists
      # (Regression #28400)
      unless params[:attribute_groups].nil?
        set_attribute_groups(params)
      end

      set_active_custom_fields

      success, errors = validate_and_save(type, user)
      if success
        after_type_save(params, options)
      else
        raise(ActiveRecord::Rollback)
      end
    end

    ServiceResult.new(success: success,
                      errors: errors,
                      result: type)
  rescue StandardError => e
    ServiceResult.new(success: false).tap do |result|
      result.errors.add(:base, e.message)
    end
  end

  def set_scalar_params(params)
    type.attributes = params.except(:attribute_groups)
  end

  def set_attribute_groups(params)
    if params[:attribute_groups].empty?
      type.reset_attribute_groups
    else
      type.attribute_groups = parse_attribute_groups_params(params)
    end
  end

  def parse_attribute_groups_params(params)
    return if params[:attribute_groups].nil?

    transform_attribute_groups(params[:attribute_groups])
  end

  def after_type_save(_params, _options)
    # noop to be overwritten by subclasses
  end

  def transform_attribute_groups(groups)
    groups.map do |group|
      if group['type'] == 'query'
        transform_query_group(group)
      else
        transform_attribute_group(group)
      end
    end
  end

  def transform_attribute_group(group)
    name =
      if group['key']
        group['key'].to_sym
      else
        group['name']
      end

    [
      name,
      group['attributes'].map { |attr| attr['key'] }
    ]
  end

  def transform_query_group(group)
    name = group['name']
    props = JSON.parse group['query']

    query = Query.new_default(name: "Embedded table: #{name}")

    ::API::V3::UpdateQueryFromV3ParamsService
      .new(query, user)
      .call(props.with_indifferent_access)

    query.show_hierarchies = false
    query.hidden = true

    [
      name,
      [query]
    ]
  end

  ##
  # Syncs attribute group settings for custom fields with enabled custom fields
  # for this type. If a custom field is not in a group, it is removed from the
  # custom_field_ids list.
  def set_active_custom_fields
    active_cf_ids = []

    type.attribute_groups.each do |group|
      group.members.each do |attribute|
        if CustomField.custom_field_attribute? attribute
          active_cf_ids << attribute.gsub(/^custom_field_/, '').to_i
        end
      end
    end

    type.custom_field_ids = active_cf_ids.uniq
  end
end
