

module ProyeksiApp
  module Webhooks
    require "proyeksi_app/webhooks/engine"
    require "proyeksi_app/webhooks/event_resources"
    require "proyeksi_app/webhooks/hook"

    @@registered_hooks = []

    ##
    # Returns a list of currently active webhooks.
    def self.registered_hooks
      @@registered_hooks.dup
    end

    ##
    # Registers a webhook having name and a callback.
    # The name will be part of the webhook-url and may be used to unregister a webhook later.
    # The callback is executed with two parameters when the webhook was called.
    #    The parameters are the hook object, an environment-variables hash and a params hash of the current request.
    # The callback may return an Integer, which is interpreted as a http return code.
    #
    # Returns the newly created hook
    def self.register_hook(name, &callback)
      raise "A hook named '#{name}' is already registered!" if find(name)

      Rails.logger.debug "incoming webhook registered: #{name}"
      hook = Hook.new(name, &callback)
      @@registered_hooks << hook
      hook
    end

    # Unregisters a webhook. Might be usefull for tests only, because routes can not
    # be redrawn in a running instance
    def self.unregister_hook(name)
      hook = find(name)
      raise "A hook named '#{name}' was not registered!" unless find(name)

      @@registered_hooks.delete hook
    end

    def self.find(name)
      @@registered_hooks.find { |h| h.name == name }
    end
  end
end
