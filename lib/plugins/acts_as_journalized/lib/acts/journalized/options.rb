

module Acts::Journalized
  # Provides +journaled+ options conjournal and cleanup.
  module Options
    def self.included(base) # :nodoc:
      base.class_eval do
        extend ClassMethods
      end
    end

    # Class methods that provide preparation of options passed to the +journaled+ method.
    module ClassMethods
      # The +prepare_journaled_options+ method has three purposes:
      # 1. Populate the provided options with default values where needed
      # 2. Prepare options for use with the +has_many+ association
      # 3. Save user-configurable options in a class-level variable
      #
      # Options are given priority in the following order:
      # 1. Those passed directly to the +journaled+ method
      # 2. Those specified in an initializer +configure+ block
      # 3. Default values specified in +prepare_journaled_options+
      def prepare_journaled_options(options)
        class_attribute :aaj_options
        self.aaj_options = options_with_defaults(options)
      end

      private

      # Returns all of the provided options suitable for the
      # has_many :journals
      # association created by aaj
      def has_many_journals_options
        aaj_options
          .slice(*ActiveRecord::Associations::Builder::HasMany
                    .send(:valid_options, { as: :irrelevant }))
      end

      def options_with_defaults(options)
        {
          class_name: Journal.name,
          dependent: :destroy,
          foreign_key: :journable_id,
          timestamp: :updated_at,
          as: :journable
        }.merge(options.symbolize_keys)
      end
    end
  end
end
