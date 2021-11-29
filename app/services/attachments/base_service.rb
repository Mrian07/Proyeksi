

module Attachments
  class BaseService < ::BaseServices::Create
    ##
    # Create an attachment service bypassing the user-provided whitelist
    # for internal purposes such as exporting data.
    #
    # @param user The user to call the service with
    # @param whitelist A custom whitelist to validate with, or empty to disable validation
    #
    # Warning: When passing an empty whitelist, this results in no validations on the content type taking place.
    def self.bypass_whitelist(user:, whitelist: [])
      new(user: user, contract_options: { whitelist: whitelist.map(&:to_s) })
    end
  end
end
