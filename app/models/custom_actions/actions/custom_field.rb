#-- encoding: UTF-8



class CustomActions::Actions::CustomField < CustomActions::Actions::Base
  def self.key
    :"custom_field_#{custom_field.id}"
  end

  def self.custom_field
    raise NotImplementedError
  end

  def custom_field
    self.class.custom_field
  end

  def human_name
    custom_field.name
  end

  def apply(work_package)
    work_package.send(:"#{custom_field.accessor_name}=", values) if work_package.respond_to?(:"#{custom_field.accessor_name}=")
  end

  def self.all
    WorkPackageCustomField
      .order(:name)
      .map do |cf|
        create_subclass(cf)
      end
  end

  def self.for(key)
    match_result = key.match /custom_field_(\d+)/

    if match_result && (cf = WorkPackageCustomField.find_by(id: match_result[1]))
      create_subclass(cf)
    end
  end

  def self.create_subclass(custom_field)
    klass = Class.new(CustomActions::Actions::CustomField)
    klass.define_singleton_method(:custom_field) do
      custom_field
    end

    klass.include(strategy(custom_field))
    klass
  end
  private_class_method :create_subclass

  def self.strategy(custom_field)
    case custom_field.field_format
    when 'string'
      CustomActions::Actions::Strategies::String
    when 'text'
      CustomActions::Actions::Strategies::Text
    when 'int'
      CustomActions::Actions::Strategies::Integer
    when 'float'
      CustomActions::Actions::Strategies::Float
    when 'date'
      CustomActions::Actions::Strategies::Date
    when 'bool'
      CustomActions::Actions::Strategies::Boolean
    when 'user'
      CustomActions::Actions::Strategies::UserCustomField
    when 'list', 'version'
      CustomActions::Actions::Strategies::AssociatedCustomField
    end
  end

  private_class_method :strategy
end
