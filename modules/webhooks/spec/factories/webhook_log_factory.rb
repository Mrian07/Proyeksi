

FactoryBot.define do
  factory :webhook_log, class: 'Webhooks::Log' do
    webhook factory: :webhook
    url { "http://example.net/webhook_receiver/42" }
    event_name { 'foobar' }
    response_code { '200' }
    request_headers { { foo: :bar } }
    request_body { 'Request body' }
    response_headers { { response: :foo } }
    response_body { 'Response body' }
  end
end
