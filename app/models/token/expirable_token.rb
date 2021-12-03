module Token
  module ExpirableToken
    extend ActiveSupport::Concern

    included do
      # Set the expiration time
      before_create :set_expiration_time

      # Remove outdated token
      after_save :delete_expired_tokens

      def valid_plaintext?(input)
        return false if expired?

        super
      end

      def expired?
        expires_on && Time.now > expires_on
      end

      def validity_time
        self.class.validity_time
      end

      ##
      # Set the expiration column
      def set_expiration_time
        self.expires_on = Time.now + validity_time
      end

      # Delete all expired tokens
      def delete_expired_tokens
        self.class.where(["expires_on < ?", Time.now]).delete_all
      end
    end

    module ClassMethods
      ##
      # Return a scope of active tokens
      def not_expired
        where(["expires_on > ?", Time.now])
      end
    end
  end
end
