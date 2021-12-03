#-- encoding: UTF-8

class UserPassword < ApplicationRecord
  belongs_to :user, inverse_of: :passwords

  # passwords must never be modified, so doing this on create should be enough
  before_create :salt_and_hash_password!

  attr_accessor :plain_password

  ##
  # Fixes the active UserPassword Type to use.
  # This could allow for an entrypoint for plugins or customization
  def self.active_type
    UserPassword::Bcrypt
  end

  ##
  # Determines whether the hashed value of +plain+ matches the stored password hash.
  def matches_plaintext?(plain, update_legacy: true)
    if hash_matches?(plain)

      # Update hash if necessary
      if update_legacy
        rehash_as_active(plain)
      end

      return true
    end

    false
  end

  ##
  # Rehash the password using the currently active strategy.
  # This replaces the password and keeps expiry date identical.
  def rehash_as_active(plain)
    active_class = UserPassword.active_type

    unless is_a?(active_class)
      active = becomes!(active_class)
      active.rehash_from_legacy(plain)

      active
    end
  rescue StandardError => e
    Rails.logger.error("Unable to re-hash UserPassword for #{user.login}: #{e.message}")
  end

  ##
  # Actually derive and save the password using +active_type+
  # We require a public interface since +becomes!+ does change the STI instance,
  # but returns, not changes the actual current object.
  def rehash_from_legacy(plain)
    self.hashed_password = derive_password!(plain)
    save!
  end

  def expired?
    days_valid = Setting.password_days_valid.to_i.days
    return false if days_valid == 0

    created_at < (Time.now - days_valid)
  end

  protected

  # Save hashed_password from the initially passed plain password
  # if it's set.
  def salt_and_hash_password!
    return if plain_password.nil?

    self.hashed_password = derive_password!(plain_password)
  end

  # Require the implementation to provide a secure comparison
  def hash_matches?(_plain)
    raise NotImplementedError, 'Must be overridden by subclass'
  end

  def derive_password!(_input)
    raise NotImplementedError, 'Must be overridden by subclass'
  end
end
