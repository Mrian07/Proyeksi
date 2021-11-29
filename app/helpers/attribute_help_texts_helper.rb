#-- encoding: UTF-8



module AttributeHelpTextsHelper
  def selectable_attributes(instance)
    available = instance.class.available_attributes
    used = AttributeHelpText.used_attributes(instance.type)

    available
      .reject { |key,| used.include? key }
      .map { |key, label| [label, key] }
      .sort_by { |label, _key| label.downcase }
  end
end
