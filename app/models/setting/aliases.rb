#-- encoding: UTF-8



class Setting
  ##
  # Shorthand to common setting aliases to avoid checking values
  module Aliases
    ##
    # Whether the application is configured to use or force SSL output
    # for cookie storage et al.
    def https?
      Setting.protocol == 'https' || Rails.configuration.force_ssl
    end
  end
end
