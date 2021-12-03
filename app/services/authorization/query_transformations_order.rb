#-- encoding: UTF-8

class Authorization::QueryTransformationsOrder
  def initialize
    self.array = []
  end

  delegate :<<, :map, to: :array

  def full_order
    partial_orders = transformation_partial_orders

    merge_transformation_partial_orders(partial_orders)
  end

  private

  attr_accessor :array

  def transformation_partial_orders
    map do |transformation|
      transformation.after + [transformation.name] + transformation.before
    end
  end

  def merge_transformation_partial_orders(partial_orders)
    desired_order = []

    until partial_orders.empty?
      order = partial_orders.shift

      shift_first_if_its_turn(order, partial_orders) do |first|
        desired_order << first
      end

      partial_orders.push(order) unless order.empty?
    end

    desired_order
  end

  def shift_first_if_its_turn(order, partial_orders)
    @rejected ||= []

    if first_not_included_or_first_everywhere(order, partial_orders)
      partial_orders.select { |o| o[0] == order[0] }.each(&:shift)

      @rejected.clear
      yield order.shift
    else
      raise "Cannot sort #{order} into the list of transformations" if @rejected.include?(order)

      @rejected << order
    end
  end

  def first_not_included_or_first_everywhere(order, partial_orders)
    partial_orders.all? { |o| !o.include?(order[0]) || o[0] == order[0] }
  end
end
