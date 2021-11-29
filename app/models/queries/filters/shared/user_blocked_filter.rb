#-- encoding: UTF-8



module Queries::Filters::Shared::UserBlockedFilter
  def self.included(base)
    base.include(InstanceMethods)
    base.extend(ClassMethods)
  end

  module InstanceMethods
    def allowed_values
      [[I18n.t(:status_blocked), :blocked]]
    end

    def type
      :list
    end

    def where
      User.blocked_condition(operator == '=')
    end
  end

  module ClassMethods
    def self.key
      :blocked
    end
  end
end
