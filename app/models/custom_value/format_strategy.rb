#-- encoding: UTF-8

class CustomValue::FormatStrategy
  attr_reader :custom_value

  delegate :custom_field, :value, to: :custom_value

  def initialize(custom_value)
    @custom_value = custom_value
  end

  def value_present?
    !value.blank?
  end

  # Returns the value of the CustomValue in a typed fashion (i.e. not as the string
  # that is used for representation in the database)
  def typed_value
    raise 'SubclassResponsibility'
  end

  # Returns the value of the CustomValue formatted to a string
  # representation.
  def formatted_value
    value.to_s
  end

  # Parses the value to
  # 1) have a unified representation for different inputs
  # 2) memoize typed values (if the subclass decides to do so
  def parse_value(val)
    self.memoized_typed_value = nil

    val
  end

  # Validates the type of the custom field and returns a symbol indicating the validation error
  # if an error occurred; returns nil if no error occurred
  def validate_type_of_value
    raise 'SubclassResponsibility'
  end

  private

  attr_accessor :memoized_typed_value
end
