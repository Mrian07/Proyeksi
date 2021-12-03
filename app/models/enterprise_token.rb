
class EnterpriseToken < ApplicationRecord
  class << self
    def current
      RequestStore.fetch(:current_ee_token) do
        set_current_token
      end
    end

    def table_exists?
      connection.data_source_exists? table_name
    end

    def allows_to?(action)
      Authorization::EnterpriseService.new(current).call(action).result
    end

    def show_banners?
      ProyeksiApp::Configuration.ee_manager_visible? && (!current || current.expired?)
    end

    def set_current_token
      token = EnterpriseToken.order(Arel.sql('created_at DESC')).first

      if token&.token_object
        token
      end
    end
  end

  validates_presence_of :encoded_token
  validate :valid_token_object
  validate :valid_domain

  before_save :unset_current_token
  before_destroy :unset_current_token

  delegate :will_expire?,
           :subscriber,
           :mail,
           :company,
           :domain,
           :issued_at,
           :starts_at,
           :expires_at,
           :reprieve_days,
           :reprieve_days_left,
           :restrictions,
           to: :token_object

  def token_object
    load_token! unless defined?(@token_object)
    @token_object
  end

  def allows_to?(action)
    Authorization::EnterpriseService.new(self).call(action).result
  end

  def unset_current_token
    # Clear current cache
    RequestStore.delete :current_ee_token
  end

  def expired?(reprieve: true)
    token_object.expired?(reprieve: reprieve) || invalid_domain?
  end

  ##
  # The domain is only validated for tokens from version 2.0 onwards.
  def invalid_domain?
    return false unless token_object&.validate_domain?

    token_object.domain != Setting.host_name
  end

  private

  def load_token!
    @token_object = ProyeksiApp::Token.import(encoded_token)
  rescue ProyeksiApp::Token::ImportError => e
    Rails.logger.error "Failed to load EE token: #{e}"
    nil
  end

  def valid_token_object
    errors.add(:encoded_token, :unreadable) unless load_token!
  end

  def valid_domain
    errors.add :domain, :invalid if invalid_domain?
  end
end
