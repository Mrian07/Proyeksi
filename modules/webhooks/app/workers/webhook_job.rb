#-- encoding: UTF-8



class WebhookJob < ApplicationJob
  attr_reader :webhook_id, :event_name

  # Retry webhook jobs three times with exponential backoff
  # in case of timeouts
  retry_on Timeout::Error,
           RestClient::RequestTimeout,
           wait: :exponentially_longer,
           attempts: 3

  def perform(webhook_id, event_name)
    @webhook_id = webhook_id
    @event_name = event_name
  end

  def webhook
    @webhook ||= Webhooks::Webhook.find(webhook_id)
  end
end
