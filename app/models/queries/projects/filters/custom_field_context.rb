#-- encoding: UTF-8



module Queries::Projects::Filters::CustomFieldContext
  class << self
    def custom_field_class
      ::ProjectCustomField
    end

    def model
      ::Project
    end

    def custom_fields(_context)
      custom_field_class.visible
    end

    def where_subselect_joins(custom_field)
      cv_db_table = CustomValue.table_name
      project_db_table = Project.table_name

      "LEFT OUTER JOIN #{cv_db_table}
         ON #{cv_db_table}.customized_type='Project'
         AND #{cv_db_table}.customized_id=#{project_db_table}.id
         AND #{cv_db_table}.custom_field_id=#{custom_field.id}"
    end
  end
end
