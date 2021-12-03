#-- encoding: UTF-8

module Queries::Register
  class << self
    def filter(query, filter)
      @filters ||= Hash.new do |hash, filter_key|
        hash[filter_key] = []
      end

      @filters[query] << filter
    end

    def order(query, order)
      @orders ||= Hash.new do |hash, order_key|
        hash[order_key] = []
      end

      @orders[query] << order
    end

    def group_by(query, group_by)
      @group_bys ||= Hash.new do |hash, group_key|
        hash[group_key] = []
      end

      @group_bys[query] << group_by
    end

    def column(query, column)
      @columns ||= Hash.new do |hash, column_key|
        hash[column_key] = []
      end

      @columns[query] << column
    end

    def register(&block)
      instance_exec(&block)
    end

    attr_accessor :filters,
                  :orders,
                  :columns,
                  :group_bys
  end
end
