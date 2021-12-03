

require 'securerandom'

FactoryBot.define do
  factory :invitation_token, class: '::Token::Invitation' do
    user
  end

  factory :api_token, class: '::Token::API' do
    user
  end

  factory :rss_token, class: '::Token::RSS' do
    user
  end

  factory :recovery_token, class: '::Token::Recovery' do
    user
  end

  factory :backup_token, class: '::Token::Backup' do
    user

    after(:build) do |token|
      token.created_at = DateTime.now - ProyeksiApp::Configuration.backup_initial_waiting_period
    end

    trait :with_waiting_period do
      transient do
        since { 0.seconds }
      end

      after(:build) do |token, factory|
        token.created_at = DateTime.now - factory.since
      end
    end
  end
end
