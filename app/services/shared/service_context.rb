#-- encoding: UTF-8

module Shared
  module ServiceContext
    private

    def in_context(model, send_notifications = true, &block)
      if model
        in_mutex_context(model, send_notifications, &block)
      else
        in_user_context(send_notifications, &block)
      end
    end

    def in_mutex_context(model, send_notifications = true, &block)
      result = nil

      ProyeksiApp::Mutex.with_advisory_lock_transaction(model) do
        result = without_context_transaction(send_notifications, &block)

        raise ActiveRecord::Rollback if result.failure?
      end

      result
    end

    def in_user_context(send_notifications = true, &block)
      result = nil

      ActiveRecord::Base.transaction do
        result = without_context_transaction(send_notifications, &block)

        raise ActiveRecord::Rollback if result.failure?
      end

      result
    end

    def without_context_transaction(send_notifications, &block)
      User.execute_as user do
        Journal::NotificationConfiguration.with(send_notifications, &block)
      end
    end
  end
end
