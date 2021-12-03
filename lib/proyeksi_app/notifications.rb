

module ProyeksiApp
  ##
  # Notifications about Events in ProyeksiApp (e.g. created work packages)
  #
  # @see ProyeksiApp::Events
  module Notifications
    module_function

    # Subscribe to a specific event with name
    # Contrary to ActiveSupport::Notifications, we don't support regexps here, but only
    # single events specified as string.
    #
    # @param name [String] The name of the event to subscribe to.
    # @param clear_subscriptions [Boolean] Clears all previous subscriptions to this
    #                                      event if true. Use with care!
    # @return [Int] Subscription ID
    # @raises ArgumentError if no block is given.
    def subscribe(name, clear_subscriptions: false, &block)
      # if no block is given, raise an error
      raise ArgumentError, 'please provide a block as a callback' unless block_given?

      if clear_subscriptions
        subscriptions[name].each do |sub|
          ActiveSupport::Notifications.unsubscribe sub
        end
      end

      sub = ActiveSupport::Notifications.subscribe(name.to_s) do |_, _, _, _, data|
        block.call(data.fetch(:payload, data))
      end

      subs = clear_subscriptions ? [] : Array(subscriptions[name])
      subscriptions[name] = subs + [sub]

      subscriptions[name].size - 1
    end

    def unsubscribe(name, id)
      sub = subscriptions[name].delete_at id

      if sub
        ActiveSupport::Notifications.unsubscribe sub

        true
      end
    end

    # Send a notification.
    # Payload should be a Hash and might be marshalled and unmarshalled before being
    # delivered (although it is not at the moment), so don't count on object equality
    # for the payload.
    def send(name, payload)
      ActiveSupport::Notifications.instrument(name.to_s, payload: payload)
    end

    def subscriptions
      @subscriptions ||= {}
    end
  end
end
