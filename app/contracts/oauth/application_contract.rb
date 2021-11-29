#-- encoding: UTF-8



module OAuth
  class ApplicationContract < ::ModelContract
    def self.model
      ::Doorkeeper::Application
    end

    validate :validate_client_credential_user

    attribute :name
    attribute :redirect_uri
    attribute :confidential
    attribute :owner_id
    attribute :owner_type
    attribute :scopes
    attribute :client_credentials_user_id

    private

    def validate_client_credential_user
      return unless model.client_credentials_user_id.present?

      unless User.where(id: model.client_credentials_user_id).exists?
        errors.add :client_credentials_user_id, :invalid
      end
    end
  end
end
