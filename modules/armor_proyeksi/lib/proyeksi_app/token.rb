require "openssl"
require "date"
require "json"
require "base64"

require 'active_model'

require "proyeksi_app/token/version"
require "proyeksi_app/token/extractor"
require "proyeksi_app/token/armor"

module ProyeksiApp
  class Token
    class Error < StandardError; end
    class ImportError < Error; end
    class ParseError < Error; end
    class ValidationError < Error; end

    class << self
      attr_reader :key, :extractor

      def key=(key)
        if key && !key.is_a?(OpenSSL::PKey::RSA)
          raise ArgumentError, "Key is missing."
        end

        @key = key
        @extractor = Extractor.new(self.key)
      end

      def import(data)
        raise ImportError, "Missing key." if key.nil?
        raise ImportError, "No token data." if data.nil?

        data = Armor.decode(data)
        json = extractor.read(data)
        attributes = JSON.parse(json)

        new(attributes)
      rescue Extractor::Error
        raise ImportError, "Token value could not be read."
      rescue JSON::ParserError
        raise ImportError, "Token value is invalid JSON."
      rescue Armor::ParseError
        raise ImportError, "Token value could not be parsed."
      end
    end

    include ActiveModel::Validations

    attr_reader :version
    attr_accessor :subscriber, :mail, :company, :domain
    attr_accessor :starts_at, :issued_at, :expires_at
    attr_accessor :reprieve_days
    attr_accessor :notify_admins_at, :notify_users_at, :block_changes_at
    attr_accessor :restrictions

    validates_presence_of :subscriber
    validates_presence_of :mail
    validates_presence_of :company, allow_blank: true
    validates_presence_of :domain, if: :validate_domain?

    validates_each(
      :starts_at, :issued_at, :expires_at, :notify_admins_at, :notify_users_at, :block_changes_at,
      allow_blank: true) do |record, attr, value|

      record.errors.add attr, 'is not a date' if !value.is_a?(Date)
    end

    validates_each :restrictions, allow_nil: true do |record, attr, value|
      record.errors.add attr, :invalid if !value.is_a?(Hash)
    end

    def initialize(attributes = {})
      load_attributes(attributes)
    end

    def will_expire?
      self.expires_at
    end

    def will_notify_admins?
      self.notify_admins_at
    end

    def will_notify_users?
      self.notify_users_at
    end

    def will_block_changes?
      self.block_changes_at
    end

    ##
    # Indicates whether or not the token has expired.
    #
    # This does include a reprieve (grace period) if configured.
    # I.e. this will return false even if `expires_at` has passed
    # if `reprieve_days` is configured, as long as the current date
    # is still within those days after the actual expiration.
    #
    # @param reprieve [Boolean] Allow for reprieve (default true)
    def expired?(reprieve: true)
      offset = reprieve ? reprieve_days.to_i : 0

      will_expire? && Date.today >= self.expires_at.next_day(offset)
    end

    ##
    # Returns the number of days of reprieve left after the token has expired.
    #
    # @return Returns `nil` if the token hasn't expired yet or if no reprieve was given.
    def reprieve_days_left
      return nil unless reprieve_days.to_i > 0 && expired?(reprieve: false)

      (self.expires_at.next_day(reprieve_days.to_i) - Date.today).to_i
    end

    def notify_admins?
      will_notify_admins? && Date.today >= self.notify_admins_at
    end

    def notify_users?
      will_notify_users? && Date.today >= self.notify_users_at
    end

    def block_changes?
      will_block_changes? && Date.today >= self.block_changes_at
    end

    # tokens with no version or a version lower than 2.0 don't have the attributes company or domain
    def validate_domain?
      version && Gem::Version.new(version) >= domain_required_from_version
    end

    def restricted?(key = nil)
      if key
        restricted? && restrictions.has_key?(key)
      else
        restrictions && restrictions.length >= 1
      end
    end

    def attributes
      hash = {}

      hash["version"]          = self.version
      hash["subscriber"]       = self.subscriber
      hash["mail"]             = self.mail
      hash["company"]          = self.company
      hash["domain"]           = self.domain

      hash["issued_at"]        = self.issued_at
      hash["starts_at"]        = self.starts_at
      hash["expires_at"]       = self.expires_at       if self.will_expire?
      hash["reprieve_days"]    = self.reprieve_days    if self.will_expire?

      hash["notify_admins_at"] = self.notify_admins_at if self.will_notify_admins?
      hash["notify_users_at"]  = self.notify_users_at  if self.will_notify_users?
      hash["block_changes_at"] = self.block_changes_at if self.will_block_changes?

      hash["restrictions"]     = self.restrictions     if self.restricted?

      hash
    end

    def to_json
      JSON.dump(self.attributes)
    end

    def from_json(json)
      load_attributes(JSON.parse(json))
    rescue => e
      raise ParseError, "Failed to load from json: #{e}"
    end

    private

    def load_attributes(attributes)
      attributes = Hash[attributes.map { |k, v| [k.to_s, v] }]

      @version = read_version attributes
      @subscriber = attributes["subscriber"]
      @mail = attributes["mail"]
      @company = attributes["company"]
      @domain = attributes["domain"]

      date_attribute_keys.each do |attr|
        value = attributes[attr]
        value = Date.parse(value) rescue nil if value.is_a?(String)

        next unless value

        send("#{attr}=", value)
      end

      reprieve_days = attributes["reprieve_days"]

      if will_expire?
        if reprieve_days.nil? && apply_default_reprieve?(version)
          @reprieve_days = 7
        else
          @reprieve_days = reprieve_days.to_i
        end
      end

      restrictions = attributes["restrictions"]

      if restrictions && restrictions.is_a?(Hash)
        restrictions = Hash[restrictions.map { |k, v| [k.to_sym, v] }]
        @restrictions = restrictions
      end
    end


    def read_version(attr)
      value = attr.include?("version") ? attr["version"] : current_gem_version.to_s
      version = nil

      if value.to_s == "1"
        version = 1
      elsif value.present? && value.to_s != "-1"
        version = Gem::Version.new value

        if version > current_gem_version
          raise ArgumentError, "Version is too new"
        end
      end

      version
    end

    def date_attribute_keys
      %w(starts_at issued_at expires_at notify_admins_at notify_users_at block_changes_at)
    end

    def current_gem_version
      @current_gem_version ||= Gem::Version.new(ProyeksiApp::Token::VERSION.to_s)
    end

    def domain_required_from_version
      @domain_required_from_version ||= Gem::Version.new('2.0')
    end

    ##
    # Reprieve was introduced in version 2.2.0 so could only be set
    # during generation from then onwards. All tokens before that
    # shall apply a default reprieve to be safe.
    def apply_default_reprieve?(version)
      Gem::Version.new(version) < Gem::Version.new("2.2.0")
    end
  end
end
