#-- encoding: UTF-8



class Queries::Notifications::Filters::ReadIanFilter < Queries::Notifications::Filters::NotificationFilter
  include Queries::Filters::Shared::BooleanFilter

  def self.key
    :read_ian
  end

  def type_strategy
    @type_strategy ||= ::Queries::Filters::Strategies::BooleanListStrict.new self
  end
end
