#-- encoding: UTF-8

module Queries::Filters::Shared::GroupFilter
  def self.included(base)
    base.include(InstanceMethods)
    base.extend(ClassMethods)
  end

  module InstanceMethods
    def allowed_values
      @allowed_values ||= begin
                            ::Group.pluck(:id).map { |g| [g, g.to_s] }
                          end
    end

    def available?
      ::Group.exists?
    end

    def type
      :list_optional
    end

    def human_name
      I18n.t('query_fields.member_of_group')
    end

    def where
      case operator
      when '='
        "users.id IN (#{group_subselect})"
      when '!'
        "users.id NOT IN (#{group_subselect})"
      when '*'
        "users.id IN (#{any_group_subselect})"
      when '!*'
        "users.id NOT IN (#{any_group_subselect})"
      end
    end

    private

    def group_subselect
      User.in_group(values).select(:id).to_sql
    end

    def any_group_subselect
      User.within_group([]).select(:id).to_sql
    end
  end

  module ClassMethods
    def key
      :group
    end
  end
end
