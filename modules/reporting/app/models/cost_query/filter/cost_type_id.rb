

class CostQuery::Filter::CostTypeId < Report::Filter::Base
  extra_options :display
  selectable false

  def self.label
    WorkPackage.human_attribute_name(:cost_type)
  end

  def initialize(child = nil, options = {})
    super
    @display = options[:display]
  end

  ##
  # @Override
  # Displayability is decided on the instance
  def display?
    return super if @display.nil?

    @display
  end

  def field
    # prevent setting an extra cost type constraint
    # WHERE cost_type_id IN (...)
    # when money value is requested
    if values == ["0"]
      []
    else
      super
    end
  end

  def self.available_values(*)
    [[::I18n.t(:caption_labor), -1]] + CostType.order(Arel.sql('name')).pluck(:name, :id)
  end
end
