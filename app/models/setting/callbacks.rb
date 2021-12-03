#-- encoding: UTF-8

class Setting
  module Callbacks
    # register a callback for a setting named #name
    def register_callback(name, &callback)
      # register the block with the underlying notifications system
      notifier.subscribe(notification_event_for(name), &callback)
    end

    # instructs the underlying notifications system to publish all setting events for setting #name
    # based on the new and old setting objects different events can be triggered
    # currently, that's whenever a setting is set regardless whether the value changed
    def fire_callbacks(name, new_value, old_value)
      notifier.send(notification_event_for(name), value: new_value, old_value: old_value)
    end

    private

    # encapsulates the event name broadcast to all subscribers
    def notification_event_for(name)
      "setting.#{name}.changed"
    end

    # the notifier to delegate to
    def notifier
      ProyeksiApp::Notifications
    end
  end
end
