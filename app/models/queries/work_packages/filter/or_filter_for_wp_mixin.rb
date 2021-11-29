#-- encoding: UTF-8



module Queries::WorkPackages::Filter::OrFilterForWpMixin
  extend ActiveSupport::Concern

  included do
    validate :minimum_one_filter_valid
  end

  def filters
    if @filters
      update_instances
    else
      @filters = create_instances
    end

    @filters.keep_if(&:validate)
  end

  def where
    filters.map(&:where).join(' OR ')
  end

  def filter_configurations
    raise NotImplementedError
  end

  def create_instances
    filter_configurations.map do |conf|
      conf.filter_class.create!(name: conf.filter_name,
                                context: context,
                                operator: conf.operator,
                                values: values)
    end
  end

  def update_instances
    configurations = filter_configurations

    @filters.each_with_index do |filter, index|
      filter.operator = configurations[index].operator
      filter.values = values
    end
  end

  def ar_object_filter?
    false
  end

  def minimum_one_filter_valid
    if filters.empty?
      errors.add(:values, :invalid)
    end
  end
end
