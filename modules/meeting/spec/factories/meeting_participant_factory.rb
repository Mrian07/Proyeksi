

FactoryBot.define do
  factory :meeting_participant do |_mp|
    user
    meeting
  end
end
