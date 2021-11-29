

require 'journal_changes'
require 'journal_formatter'

module Acts
end

Dir[File.expand_path('acts/journalized/*.rb', __dir__)].sort.each { |f| require f }

module Acts
  module Journalized
    def self.included(base)
      base.extend ClassMethods
      base.extend Journalized
    end

    module ClassMethods
      def plural_name
        name.underscore.pluralize
      end

      # This call will start journaling the model.
      def acts_as_journalized(options = {})
        return if journaled?

        include_aaj_modules

        prepare_journaled_options(options)

        has_many :journals, -> {
          order("#{Journal.table_name}.version ASC")
        }, **has_many_journals_options
      end

      private

      def include_aaj_modules
        include Options
        include Creation
        include Reversion
        include Permissions
        include SaveHooks
        include FormatHooks
        include DataClass
      end
    end
  end
end
