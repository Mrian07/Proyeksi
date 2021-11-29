

FactoryBot.define do
  factory :user_preference do
    user
    hide_mail { true }
    transient do
      others { {} }
    end

    callback(:after_build) do |pref, evaluator|
      Hash(evaluator.others).each do |k, v|
        pref[k] = v
      end
    end
  end
end
