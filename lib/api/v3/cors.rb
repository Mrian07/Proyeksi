#-- encoding: UTF-8



# CORS helper methods for the API v3
module API
  module V3
    module CORS
      ##
      # Returns whether CORS headers should
      # be set on the APIv3 resources
      def self.enabled?
        Setting.apiv3_cors_enabled?
      end

      ##
      # Determine whether the given origin is included
      # in the allowed origin list
      def self.allowed?(source)
        Setting.apiv3_cors_origins.include?(source)
      end
    end
  end
end
