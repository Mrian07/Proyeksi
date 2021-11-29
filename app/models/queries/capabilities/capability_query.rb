

class Queries::Capabilities::CapabilityQuery < Queries::BaseQuery
  def self.model
    Capability
  end

  def results
    super
      .reorder('action ASC', 'principal_id ASC', 'capabilities.context_id ASC')
  end

  def default_scope
    Capability
      .default
      .distinct
  end

  validate :minimum_filters_set

  private

  def minimum_filters_set
    any_required = filters.any? do |filter|
      [Queries::Capabilities::Filters::PrincipalIdFilter,
       Queries::Capabilities::Filters::ContextFilter,
       Queries::Capabilities::Filters::IdFilter].include?(filter.class) && filter.operator == '='
    end

    errors.add(:filters, I18n.t('activerecord.errors.models.capability.query.filters.minimum')) unless any_required
  end
end
