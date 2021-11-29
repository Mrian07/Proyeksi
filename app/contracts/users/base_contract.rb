#-- encoding: UTF-8



module Users
  class BaseContract < ::ModelContract
    include AssignableCustomFieldValues

    attribute :login,
              writeable: ->(*) { user.allowed_to_globally?(:manage_user) && model.id != user.id }
    attribute :firstname
    attribute :lastname
    attribute :mail
    attribute :admin,
              writeable: ->(*) { user.admin? && model.id != user.id }
    attribute :language

    attribute :auth_source_id,
              writeable: ->(*) { user.allowed_to_globally?(:manage_user) }

    attribute :identity_url,
              writeable: ->(*) { user.admin? }

    attribute :force_password_change,
              writeable: ->(*) { user.admin? }

    def self.model
      User
    end

    validate :validate_password_writable
    validate :existing_auth_source

    delegate :available_custom_fields, to: :model

    def reduce_writable_attributes(attributes)
      super.tap do |writable|
        writable << 'password' if password_writable?
      end
    end

    private

    ##
    # Password is not a regular attribute so it bypasses
    # attribute writable checks
    def password_writable?
      user.admin? || user.id == model.id
    end

    ##
    # User#password is not an ActiveModel property,
    # but just an accessor, so we need to identify it being written there.
    # It is only present when freshly written
    def validate_password_writable
      # Only admins or the user themselves can set the password
      return if password_writable?

      errors.add :password, :error_readonly if model.password.present?
    end

    def existing_auth_source
      if auth_source_id && AuthSource.find_by_unique(auth_source_id).nil?
        errors.add :auth_source, :error_not_found
      end
    end
  end
end
