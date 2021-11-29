#-- encoding: UTF-8



module Queries::WorkPackages::Filter::FilterForWpMixin
  def type
    :list
  end

  def allowed_values
    raise NotImplementedError, 'There would be too many candidates'
  end

  def value_objects
    objects = visible_scope.find(no_templated_values)

    if has_templated_value?
      objects << ::Queries::Filters::TemplatedValue.new(WorkPackage)
    end

    objects
  end

  def allowed_objects
    raise NotImplementedError, 'There would be too many candidates'
  end

  def available?
    key = 'Queries::WorkPackages::Filter::FilterForWpMixin/available'

    RequestStore.fetch(key) do
      visible_scope.exists?
    end
  end

  def ar_object_filter?
    true
  end

  def allowed_values_subset
    id_values = visible_scope.where(id: no_templated_values).pluck(:id).map(&:to_s)

    if has_templated_value?
      id_values + templated_value_keys
    else
      id_values
    end
  end

  private

  def visible_scope
    if context.project
      WorkPackage
        .visible
        .for_projects(context.project.self_and_descendants)
    else
      WorkPackage.visible
    end
  end

  def type_strategy
    @type_strategy ||= Queries::Filters::Strategies::HugeList.new(self)
  end

  def no_templated_values
    values.reject { |v| templated_value_keys.include? v }
  end

  def templated_value_keys
    [templated_value_key, deprecated_templated_value_key]
  end

  def templated_value_key
    ::Queries::Filters::TemplatedValue::KEY
  end

  def deprecated_templated_value_key
    ::Queries::Filters::TemplatedValue::DEPRECATED_KEY
  end

  def has_templated_value?
    (values & templated_value_keys).any?
  end
end
