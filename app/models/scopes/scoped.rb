module Scopes::Scoped
  extend ActiveSupport::Concern

  included do
    def self.scopes(*classes)
      classes.each do |klass|
        include "#{name.pluralize}::Scopes::#{klass.to_s.camelize}".constantize
      end
    end
  end
end
