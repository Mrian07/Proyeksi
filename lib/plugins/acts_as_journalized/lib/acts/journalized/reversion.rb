

module Acts::Journalized
  # Enables versioned ActiveRecord::Base instances to revert to a previously saved version.
  module Reversion
    def self.included(base) # :nodoc:
      base.class_eval do
        include InstanceMethods
      end
    end

    # Provides the base instance methods required to revert a journaled instance.
    module InstanceMethods
      def last_journal
        journals.last
      end

      # some eager loading may mess up the order
      # journals.order('created_at').last will not work
      # (especially when journals already filtered)
      # thats why this method exists
      # it is impossible to incorporate this into #last_journal
      # because some logic is based on this eager loading bug/feature
      def last_loaded_journal
        if journals.loaded?
          journals.max_by(&:version)
        end
      end

      private

      # Returns the number of the last created journal in the object's journal history.
      #
      # If no associated journals exist, the object is considered at version 0.
      def last_version
        @last_version ||= journals.maximum(:version) || 0
      end
    end
  end
end
