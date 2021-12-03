module Authentication
  class OmniauthAuthHashContract
    include ActiveModel::Validations

    attr_reader :auth_hash

    def initialize(auth_hash)
      @auth_hash = auth_hash
    end

    validate :validate_auth_hash
    validate :validate_auth_hash_not_expired
    validate :validate_authorization_callback

    private

    def validate_auth_hash
      return if auth_hash&.valid?

      errors.add(:base, I18n.t(:error_omniauth_invalid_auth))
    end

    def validate_auth_hash_not_expired
      return unless auth_hash['timestamp']

      if auth_hash['timestamp'] < Time.now - 30.minutes
        errors.add(:base, I18n.t(:error_omniauth_registration_timed_out))
      end
    end

    def validate_authorization_callback
      return unless auth_hash&.valid?

      decision = ProyeksiApp::OmniAuth::Authorization.authorized?(auth_hash)
      errors.add(:base, decision.message) unless decision.approve?
    end
  end
end
