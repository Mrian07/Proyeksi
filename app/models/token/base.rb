module Token
  class Base < ApplicationRecord
    self.table_name = 'tokens'

    # Hashed tokens belong to a user and are unique per type
    belongs_to :user

    # Create a plain and hashed value when creating a new token
    after_initialize :initialize_values

    # Ensure uniqueness of the token value
    validates_presence_of :value
    validates_uniqueness_of :value

    # Delete previous token of this type upon save
    before_save :delete_previous_token

    ##
    # Find a token from the token value
    def self.find_by_plaintext_value(input)
      find_by(value: input)
    end

    ##
    # Generate a random hex token value
    def self.generate_token_value
      SecureRandom.hex(32)
    end

    protected

    ##
    # Allows only a single value of the token?
    def single_value?
      true
    end

    # Removes obsolete tokens (same user and action)
    def delete_previous_token
      if single_value? && user
        self.class.where(user_id: user.id, type: type).delete_all
      end
    end

    def initialize_values
      if new_record? && !value.present?
        self.value = self.class.generate_token_value
      end
    end
  end
end
