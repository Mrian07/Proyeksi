#-- encoding: UTF-8



module ::Bim::Queries::WorkPackages::Filter
  class BcfIssueAssociatedFilter < ::Queries::WorkPackages::Filter::WorkPackageFilter
    attr_reader :join_table_suffix

    def type
      :list
    end

    def allowed_values
      [
        [I18n.t(:general_text_yes), OpenProject::Database::DB_VALUE_TRUE],
        [I18n.t(:general_text_no), OpenProject::Database::DB_VALUE_FALSE]
      ]
    end

    def where
      if associated?
        ::Queries::Operators::All.sql_for_field(values, ::Bim::Bcf::Issue.table_name, 'id')
      elsif not_associated?
        ::Queries::Operators::None.sql_for_field(values, ::Bim::Bcf::Issue.table_name, 'id')
      else
        raise 'Unsupported operator or value'
      end
    end

    def includes
      :bcf_issue
    end

    def type_strategy
      @type_strategy ||= ::Queries::Filters::Strategies::BooleanList.new self
    end

    def dependency_class
      '::API::V3::Queries::Schemas::BooleanFilterDependencyRepresenter'
    end

    def available?
      OpenProject::Configuration.bim?
    end

    private

    def associated?
      (operator == '=' && values.first == OpenProject::Database::DB_VALUE_TRUE) ||
        (operator == '!' && values.first == OpenProject::Database::DB_VALUE_FALSE)
    end

    def not_associated?
      (operator == '=' && values.first == OpenProject::Database::DB_VALUE_FALSE) ||
        (operator == '!' && values.first == OpenProject::Database::DB_VALUE_TRUE)
    end
  end
end
