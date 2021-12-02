#-- encoding: UTF-8



module ProyeksiApp
  module NullDbFallback
    class << self
      def fallback
        ActiveRecord::Base.connection
      rescue ActiveRecord::NoDatabaseError => e
        Rails.logger.error "Database connection could not be established: #{e}. Falling back to NullDB."
        applied!
        ActiveRecord::Base.establish_connection adapter: :nulldb
      end

      def reset
        return unless applied?

        ActiveRecord::Base.establish_connection(database_config)
      end

      private

      attr_accessor :applied

      def applied!
        self.applied = true
      end

      def unapplied!
        self.applied = false
      end

      def applied?
        !!applied
      end

      def database_config
        YAML.load_file(File.join(Rails.root, "config", "database.yml"))[Rails.env]
      end
    end
  end
end
