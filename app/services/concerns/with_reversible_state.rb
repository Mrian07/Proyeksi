#-- encoding: UTF-8

module WithReversibleState
  extend ActiveSupport::Concern

  included do
    attr_reader :state

    around_call :assign_state

    ##
    # Reuse or append state to the service
    def with_state(state = {})
      @state = ::Shared::ServiceState.build(state)
      self
    end

    ##
    # Access to the shared service state
    def state
      @state ||= ::Shared::ServiceState.build
    end

    ##
    # Rollback changes made
    def rollback
      # Nothing to do by default
    end

    ##
    # Assign state to the service result
    def assign_state
      yield.tap do |call|
        state.called!(self)
        call.state = state
      end
    end
  end
end
