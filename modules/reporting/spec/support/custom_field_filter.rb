

module ProyeksiApp::Reporting::SpecHelper
  module CustomFieldFilterHelper
    def group_by_class_name_string(custom_field)
      id = custom_field.is_a?(ActiveRecord::Base) ? custom_field.id : custom_field

      "CostQuery::GroupBy::CustomField#{id}"
    end

    def filter_class_name_string(custom_field)
      id = custom_field.is_a?(ActiveRecord::Base) ? custom_field.id : custom_field

      "CostQuery::Filter::CustomField#{id}"
    end
  end
end
