#-- encoding: UTF-8

module Members::Scopes
  module NotLocked
    extend ActiveSupport::Concern

    class_methods do
      # Find all members whose principals are not locked.
      def not_locked
        includes(:principal)
          .references(:principals)
          .merge(Principal.not_locked, rewhere: true)
      end
    end
  end
end
