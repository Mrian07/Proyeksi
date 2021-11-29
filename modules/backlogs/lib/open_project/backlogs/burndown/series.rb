

module OpenProject::Backlogs::Burndown
  class Series < Array
    def initialize(*args)
      @unit = args.pop
      @name = args.pop.to_sym
      @display = true

      raise "Unsupported unit '#{@unit}'" unless %i[points hours].include? @unit

      super(*args)
    end

    attr_reader :unit, :name
    attr_accessor :display
  end
end
