module CustomActions::Register
  class << self
    def action(action)
      @actions ||= []

      @actions << action
    end

    def condition(condition)
      @conditions ||= []

      @conditions << condition
    end

    attr_accessor :actions,
                  :conditions
  end
end
