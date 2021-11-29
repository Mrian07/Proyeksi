

module Acts::Journalized
  # Simply adds a flag to determine whether a model class if journaled.
  module Journalized
    def self.extended(base) # :nodoc:
      base.class_eval do
        class << self
          prepend ClassMethods
        end
      end
    end

    module ClassMethods
      # Overrides the +journaled+ method to first define the +journaled?+ class method before
      # deferring to the original +journaled+.
      def acts_as_journalized(*args)
        super(*args)

        class << self
          def journaled?
            true
          end
        end
      end
    end

    # For all ActiveRecord::Base models that do not call the +journaled+ method, the +journaled?+
    # method will return false.
    def journaled?
      false
    end
  end
end
