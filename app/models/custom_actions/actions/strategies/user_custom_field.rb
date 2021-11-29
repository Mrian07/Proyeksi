#-- encoding: UTF-8



module CustomActions::Actions::Strategies::UserCustomField
  include CustomActions::Actions::Strategies::CustomField
  include ::CustomActions::Actions::Strategies::MeAssociated

  def apply(work_package)
    if work_package.respond_to?(:"#{custom_field.accessor_name}=")
      work_package.send(:"#{custom_field.accessor_name}=", transformed_value(values.first))
    end
  end

  def available_principles
    custom_field
      .possible_values_options
      .map { |label, value| [value.empty? ? nil : value.to_i, label] }
  end
end
