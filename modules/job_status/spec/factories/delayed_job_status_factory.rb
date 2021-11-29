

FactoryBot.define do
  factory :delayed_job_status, class: '::JobStatus::Status' do
    job_id { SecureRandom.uuid }
    user { User.current }
  end
end
