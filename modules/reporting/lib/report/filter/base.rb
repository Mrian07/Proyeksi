

class Report::Filter
  class Base < Report::Chainable
    include Report::QueryUtils
    engine::Operator.load

    inherited_attribute :available_operators,
                        list: true, map: :to_operator,
                        uniq: true
    inherited_attribute :default_operator, map: :to_operator

    accepts_property :values, :value, :operator

    mattr_accessor :skip_inherited_operators
    self.skip_inherited_operators = [:time_operators, 'y', 'n']

    attr_accessor :values

    def cache_key
      self.class.cache_key + operator.to_s + Array(values).join(',')
    end

    ##
    # A Filter is 'heavy' if it possibly returns a _hugh_ number of available_values.
    # In that case the UI-guys should think twice about displaying all the values.
    def self.heavy?
      false
    end

    # Indicates whether this Filter is a multiple choice filter,
    # meaning that the user must select a value of a given set of choices.
    def self.is_multiple_choice?
      false
    end

    # need this for sort
    def <=>(other)
      self.class.underscore_name <=> other.class.underscore_name
    end

    def self.cached(*args)
      @cached ||= {}
      @cached[args] ||= send(*args)
    end

    def value=(val)
      self.values = [val]
    end

    ##
    # Always empty. You may include additional_operators as a filter module.
    # This is here for the case you don't.
    def additional_operators
      []
    end

    def self.use(*names)
      operators = []
      names.each do |name|
        dont_inherit :available_operators if skip_inherited_operators.include? name
        case name
        when String, engine::Operator then operators << name.to_operator
        when Symbol then operators.push(*engine::Operator.send(name))
        else fail "dunno what to do with #{name.inspect}"
        end
      end
      available_operators *operators
    end

    use :default_operators

    def self.new(*args, &block) # :nodoc:
      # this class is abstract. instances are only allowed from child classes
      raise "#{name} is an abstract class" if base?

      super
    end

    def self.inherited(klass)
      if base?
        dont_display!
        klass.display!
      end
      super
    end

    ##
    # Returns an array of [:label_of_value, value]-kind arrays, containing
    # valid id-label combinations of possible filter values
    def self.available_values(_params = {})
      []
    end

    ##
    # Returns a [:label_of_value, value]-kind array (as in self.vailable_values)
    # for the given value
    def self.label_for_value(value)
      available_values(reverse_search: true).find { |v| v.second == value || v.second.to_s == value }
    end

    def correct_position?
      child.nil? or child.filter?
    end

    def from_for(scope)
      super + self.class.table_joins
    end

    def filter?
      true
    end

    def valid?
      @operator ? @operator.validate(values) : true
    end

    def errors
      @operator ? @operator.errors : []
    end

    def group_by_fields
      []
    end

    def initialize(child = nil, options = {})
      @values = []
      super
    end

    def might_be_responsible
      parent
    end

    def operator
      (@operator || self.class.default_operator || engine::Operator.default_operator).to_operator
    end

    def operator=(value)
      @operator = value.to_operator.tap do |o|
        unless available_operators.include?(o) || additional_operators.include?(o)
          raise ArgumentError, "#{o.inspect} not supported by #{inspect}."
        end
      end
    end

    def responsible_for_sql?
      top?
    end

    def to_hash
      raise NotImplementedError
    end

    def transformed_values
      values
    end

    def sql_statement
      super.tap do |query|
        arity = operator.arity
        query_values = [*transformed_values].compact
        # if there is just the nil it might be actually intendet to be there
        query_values.unshift nil if Array(values).size == 1 && Array(values).first.nil?
        query_values = query_values[0, arity] if query_values and arity >= 0 and arity != query_values.size
        operator.modify(query, field, *query_values) unless field.empty?
      end
    end
  end
end
