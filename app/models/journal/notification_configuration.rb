#-- encoding: UTF-8



class Journal::NotificationConfiguration
  class << self
    # Allows controlling whether notifications are sent out for created journals.
    # After the block is executed, the setting is returned to its original state which is true by default.
    # In case the method is called multiple times within itself, the first setting prevails.
    # This allows to control the setting globally without having to pass the setting down the call stack in
    # order to ensure all subsequent code follows the provided setting.
    def with(send_notifications, &block)
      if already_set?
        log_warning(send_notifications)
        yield
      else
        with_first(send_notifications, &block)
      end
    end

    def active?
      active.value
    end

    protected

    def with_first(send_notifications)
      old_value = active?
      self.already_set = true

      self.active = send_notifications

      yield
    ensure
      self.active = old_value
      self.already_set = false
    end

    def log_warning(send_notifications)
      return if active == send_notifications

      message = <<~MSG
        Ignoring setting journal notifications to '#{send_notifications}' as a parent block already set it to #{active}"
      MSG
      Rails.logger.debug message
    end

    def active
      @active ||= Concurrent::ThreadLocalVar.new(true)
    end

    def already_set
      @already_set ||= Concurrent::ThreadLocalVar.new(false)
    end

    def already_set?
      already_set.value
    end

    def active=(value)
      @active.value = value
    end

    def already_set=(value)
      @already_set.value = value
    end
  end
end
