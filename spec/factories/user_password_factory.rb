

FactoryBot.define do
  factory :user_password, class: UserPassword.active_type do
    association :user
    plain_password { 'adminADMIN!' }

    factory :old_user_password do
      created_at { 1.year.ago }
      updated_at { 1.year.ago }
    end
  end

  factory :legacy_sha1_password, class: 'UserPassword::SHA1' do
    association :user
    type { 'UserPassword::SHA1' }
    plain_password { 'mylegacypassword!' }

    # Avoid going through the after_save hook
    # As it's no longer possible for Sha1 passwords
    after(:build) do |obj|
      obj.salt = SecureRandom.hex(16)
      obj.hashed_password = obj.send(:derive_password!, obj.plain_password)
      obj.plain_password = nil
    end
  end
end
