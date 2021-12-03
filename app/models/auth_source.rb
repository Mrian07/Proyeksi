#-- encoding: UTF-8

class AuthSource < ApplicationRecord
  include Redmine::Ciphering

  has_many :users

  validates :name,
            uniqueness: { case_sensitive: false },
            length: { maximum: 60 }

  def self.unique_attribute
    :name
  end

  prepend ::Mixins::UniqueFinder

  def authenticate(_login, _password)
    ;
  end

  def find_user(_login)
    raise "subclass repsonsiblity"
  end

  # implemented by a subclass, should raise when no connection is possible and not raise on success
  def test_connection
    raise I18n.t('auth_source.using_abstract_auth_source')
  end

  def auth_method_name
    'Abstract'
  end

  def account_password
    read_ciphered_attribute(:account_password)
  end

  def account_password=(arg)
    write_ciphered_attribute(:account_password, arg)
  end

  def allow_password_changes?
    self.class.allow_password_changes?
  end

  # Does this auth source backend allow password changes?
  def self.allow_password_changes?
    false
  end

  # Try to authenticate a user not yet registered against available sources
  def self.authenticate(login, password)
    AuthSource.where(['onthefly_register=?', true]).each do |source|
      begin
        Rails.logger.debug { "Authenticating '#{login}' against '#{source.name}'" }
        attrs = source.authenticate(login, password)
      rescue StandardError => e
        Rails.logger.error "Error during authentication: #{e.message}"
        attrs = nil
      end
      return attrs if attrs
    end
    nil
  end

  def self.find_user(login)
    AuthSource.where(['onthefly_register=?', true]).each do |source|
      begin
        Rails.logger.debug { "Looking up '#{login}' in '#{source.name}'" }
        attrs = source.find_user login
      rescue StandardError => e
        Rails.logger.error "Error during authentication: #{e.message}"
        attrs = nil
      end

      return attrs if attrs
    end
    nil
  end
end
