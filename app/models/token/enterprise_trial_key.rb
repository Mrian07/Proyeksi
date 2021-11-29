#-- encoding: UTF-8



require_dependency 'token/base'

module Token
  class EnterpriseTrialKey < Base
    include ExpirableToken

    def self.validity_time
      1.days
    end
  end
end
