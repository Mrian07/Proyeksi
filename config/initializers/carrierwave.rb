

require 'fog/aws'
require 'carrierwave'
require 'carrierwave/storage/fog'

module CarrierWave
  module Configuration
    def self.configure_fog!(credentials: OpenProject::Configuration.fog_credentials,
                            directory: OpenProject::Configuration.fog_directory,
                            public: false)

      # Ensure that the provider AWS is uppercased
      provider = credentials[:provider] || 'AWS'
      if [:aws, 'aws'].include? provider
        credentials[:provider] = 'AWS'
      end

      CarrierWave.configure do |config|
        config.fog_provider    = 'fog/aws'
        config.fog_credentials = credentials
        config.fog_directory   = directory
        config.fog_public      = public

        config.use_action_status = true
      end
    end
  end
end

unless OpenProject::Configuration.fog_credentials.empty?
  CarrierWave::Configuration.configure_fog!
end
