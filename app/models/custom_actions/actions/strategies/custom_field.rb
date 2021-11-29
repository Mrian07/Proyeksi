#-- encoding: UTF-8



module CustomActions::Actions::Strategies::CustomField
  def apply(work_package)
    work_package.send(:"#{custom_field.accessor_name}=", values) if work_package.respond_to?(:"#{custom_field.accessor_name}=")
  end

  def required?
    custom_field.required?
  end

  def multi_value?
    custom_field.multi_value?
  end
end
