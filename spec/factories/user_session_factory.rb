

FactoryBot.define do
  factory :user_session, class: '::Sessions::SqlBypass' do
    to_create { |instance| instance.save }
    # AR::SessionStore::SqlStore#initialize requires an attribute
    initialize_with { new(**attributes) }
    sequence(:session_id) { |n| "session_#{n}" }

    transient do
      user { nil }
      data { {} }
    end

    callback(:after_build) do |session, evaluator|
      session.data = evaluator.data
      session.data['user_id'] = evaluator.user&.id
    end
  end
end
