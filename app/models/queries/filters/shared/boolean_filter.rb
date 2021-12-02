#-- encoding: UTF-8



module Queries::Filters::Shared::BooleanFilter
  def allowed_values
    [
      [I18n.t(:general_text_yes), ProyeksiApp::Database::DB_VALUE_TRUE],
      [I18n.t(:general_text_no), ProyeksiApp::Database::DB_VALUE_FALSE]
    ]
  end

  def type
    :list
  end

  def type_strategy
    @type_strategy ||= ::Queries::Filters::Strategies::BooleanList.new self
  end
end
