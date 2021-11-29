require 'rest-client'

#-- encoding: UTF-8


class RepresentedWebhookJob < WebhookJob
  include ::OpenProjectErrorHelper

  attr_reader :resource

  def perform(webhook_id, resource, event_name)
    @resource = resource
    super(webhook_id, event_name)

    return unless accepted_in_project?

    body = request_body
    headers = request_headers
    exception = nil
    response = nil

    if signature = request_signature(body)
      headers['X-OP-Signature'] = signature
    end

    begin
      response = RestClient.post webhook.url, request_body, headers
    rescue RestClient::RequestTimeout => e
      response = e.response
      exception = e
    rescue RestClient::Exception => e
      response = e.response
      exception = e
    rescue StandardError => e
      op_handle_error(e.message, reference: :webhook_job)
      exception = e
    end

    ::Webhooks::Log.create(
      webhook: webhook,
      event_name: event_name,
      url: webhook.url,
      request_headers: headers,
      request_body: body,
      response_code: response.try(:code).to_i,
      response_headers: response.try(:headers),
      response_body: response.try(:to_s) || exception.try(:message)
    )

    # We want to re-raise timeout exceptions
    # but log the request beforehand
    if exception&.is_a?(RestClient::RequestTimeout)
      raise exception
    end
  end

  def accepted_in_project?
    webhook.enabled_for_project?(resource.project_id)
  end

  def request_signature(request_body)
    if secret = webhook.secret.presence
      'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, request_body)
    end
  end

  def request_headers
    {
      content_type: "application/json",
      accept: "application/json"
    }
  end

  def payload_key
    raise NotImplementedError
  end

  def payload_representer
    raise NotImplementedError
  end

  def request_body
    {
      :action => event_name,
      payload_key => payload_representer
    }.to_json
  end
end
