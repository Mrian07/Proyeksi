#-- encoding: UTF-8



class Setting
  ##
  # Shorthand to common setting aliases to avoid checking values
  module SelfRegistration
    VALUES = {
      disabled: 0,
      activation_by_email: 1,
      manual_activation: 2,
      automatic_activation: 3
    }.freeze

    def self.values
      VALUES
    end

    def self.value(key:)
      VALUES[key]
    end

    def self.key(value:)
      VALUES.find { |_k, v| v == value || v.to_s == value.to_s }&.first
    end

    def self.disabled
      value key: :disabled
    end

    def self.disabled?
      key(value: Setting.self_registration) == :disabled
    end

    def self.by_email
      value key: :activation_by_email
    end

    def self.by_email?
      key(value: Setting.self_registration) == :activation_by_email
    end

    def self.manual
      value key: :manual_activation
    end

    def self.manual?
      key(value: Setting.self_registration) == :manual_activation
    end

    def self.automatic
      value key: :automatic_activation
    end

    def self.automatic?
      key(value: Setting.self_registration) == :automatic_activation
    end
  end
end
