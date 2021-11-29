#-- encoding: UTF-8



class CustomActions::Actions::Base
  attr_reader :values

  DEFAULT_PRIORITY = 100

  def initialize(values = [])
    self.values = values
  end

  def values=(values)
    @values = Array(values)
  end

  def allowed_values
    raise NotImplementedError
  end

  def type
    raise NotImplementedError
  end

  def apply(_work_package)
    raise NotImplementedError
  end

  def human_name
    WorkPackage.human_attribute_name(self.class.key)
  end

  def self.key
    raise NotImplementedError
  end

  def self.all
    [self]
  end

  def self.for(key)
    if key == self.key
      self
    end
  end

  def key
    self.class.key
  end

  def required?
    false
  end

  def multi_value?
    false
  end

  def validate(errors)
    validate_value_required(errors)
    validate_only_one_value(errors)
  end

  def priority
    DEFAULT_PRIORITY
  end

  private

  def validate_value_required(errors)
    if required? && values.empty?
      errors.add :actions,
                 :empty,
                 name: human_name
    end
  end

  def validate_only_one_value(errors)
    if !multi_value? && values.length > 1
      errors.add :actions,
                 :only_one_allowed,
                 name: human_name
    end
  end
end
