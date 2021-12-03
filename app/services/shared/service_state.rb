#-- encoding: UTF-8

require "ostruct"

##
# Service state object to be passed around services
# for remembering state between service calls (e.g., when copying).
#
# Borrows heavily from interactor gem's context class at
# https://github.com/collectiveidea/interactor
module Shared
  class ServiceState < OpenStruct
    ##
    # Builds the context object unless
    # it's already an instance of this context.
    def self.build(state = {})
      self === state ? state : new(state)
    end

    ##
    # Remember that the state was passed to the given service
    def called!(service)
      service_chain << service
    end

    # Roll back the context on all used services
    def rollback!
      return false if @rolled_back

      service_chain.reverse_each do |service|
        Rails.logger.debug { "[Service state] Rolling back execution of #{service}." }
        service.rollback
      end
      @rolled_back = true
    end

    # Remembered service calls this context was used against
    def service_chain
      @service_chain ||= []
    end
  end
end
