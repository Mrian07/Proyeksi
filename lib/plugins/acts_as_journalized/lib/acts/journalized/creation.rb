

module Acts::Journalized
  # Adds the functionality necessary to control journal creation on a journaled instance of
  # ActiveRecord::Base.
  module Creation
    def self.included(base) # :nodoc:
      base.class_eval do
        include InstanceMethods

        class << self
          prepend ClassMethods
        end
      end
    end

    module InstanceMethods
      # Returns an array of column names that are journaled.
      def journaled_columns_names
        self.class.journal_class.journaled_attributes
      end

      # Returns the activity type. Should be overridden in the journalized class to offer
      # multiple types
      def activity_type
        self.class.name.underscore.pluralize
      end
    end
  end
end
