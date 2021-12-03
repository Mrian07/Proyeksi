#-- encoding: UTF-8

require_dependency 'token/base'

module Token
  class Recovery < Base
    include ExpirableToken

    def self.validity_time
      1.day
    end
  end
end
