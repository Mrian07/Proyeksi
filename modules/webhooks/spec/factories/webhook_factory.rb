

FactoryBot.define do
  factory :webhook, class: 'Webhooks::Webhook' do
    name { "Example Webhook" }
    url { "http://example.net/webhook_receiver/42" }
    description { "This is an example webhook" }
    secret { "42" }
    enabled { true }
    all_projects { true }
  end
end
