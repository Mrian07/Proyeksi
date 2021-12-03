#-- encoding: UTF-8

module Queries::Filters::Shared::UserStatusFilter
  def self.included(base)
    base.include(InstanceMethods)
    base.extend(ClassMethods)
  end

  module InstanceMethods
    def allowed_values
      Principal.statuses.keys.map do |key|
        [I18n.t(:"status_#{key}"), key]
      end
    end

    def type
      :list
    end

    def status_values
      values.map { |value| Principal.statuses[value.to_sym] }
    end

    def where
      case operator
      when "="
        ["users.status IN (?)", status_values]
      when "!"
        ["users.status NOT IN (?)", status_values]
      end
    end
  end

  module ClassMethods
    def self.key
      :status
    end
  end
end
