

FactoryBot.define do
  factory :user, parent: :principal, class: 'User' do
    firstname { 'Bob' }
    lastname { 'Bobbit' }
    sequence(:login) { |n| "bob#{n}" }
    sequence(:mail) { |n| "bobmail#{n}.bobbit@bob.com" }
    password { 'adminADMIN!' }
    password_confirmation { 'adminADMIN!' }

    transient do
      preferences { {} }
    end

    language { 'en' }
    status { User.statuses[:active] }
    admin { false }
    first_login { false if User.table_exists? and User.columns.map(&:name).include? 'first_login' }

    transient do
      global_permissions { [] }
    end

    callback(:after_build) do |user, evaluator|
      evaluator.preferences.each do |key, val|
        user.pref[key] = val
      end
    end

    callback(:after_create) do |user, factory|
      user.pref.save if factory.preferences.present?

      if user.notification_settings.empty?
        all_true = NotificationSetting.all_settings.index_with(true)
        user.notification_settings = [
          FactoryBot.create(:notification_setting, user: user, **all_true)
        ]
      end

      if factory.global_permissions.present?
        global_role = FactoryBot.create :global_role, permissions: factory.global_permissions
        FactoryBot.create :global_member, principal: user, roles: [global_role]
      end
    end

    callback(:after_stub) do |user, evaluator|
      if evaluator.preferences.present?
        user.preference = FactoryBot.build_stubbed(:user_preference, user: user, settings: evaluator.preferences)
      end
    end

    factory :admin do
      firstname { 'OpenProject' }
      sequence(:lastname) { |n| "Admin#{n}" }
      sequence(:login) { |n| "admin#{n}" }
      sequence(:mail) { |n| "admin#{n}@example.com" }
      admin { true }
      first_login { false if User.table_exists? and User.columns.map(&:name).include? 'first_login' }
    end

    factory :deleted_user, class: 'DeletedUser'

    factory :locked_user do
      firstname { 'Locked' }
      lastname { 'User' }
      sequence(:login) { |n| "bob#{n}" }
      sequence(:mail) { |n| "bob#{n}.bobbit@bob.com" }
      password { 'adminADMIN!' }
      password_confirmation { 'adminADMIN!' }
      status { User.statuses[:locked] }
    end

    factory :invited_user do
      status { User.statuses[:invited] }
    end
  end

  factory :anonymous, class: 'AnonymousUser' do
    initialize_with { User.anonymous }
  end

  factory :system, class: 'SystemUser' do
    initialize_with { User.system }
  end
end
