#-- encoding: UTF-8



require 'spec_helper'

describe RootSeeder,
         'standard edition',
         with_config: { edition: 'standard' },
         with_settings: { journal_aggregation_time_minutes: 0 } do
  it 'create the demo data' do
    expect { described_class.new.do_seed! }.not_to raise_error

    expect(User.where(admin: true).count).to eq 1
    expect(Project.count).to eq 2
    expect(WorkPackage.count).to eq 33
    expect(Wiki.count).to eq 2
    expect(Query.where.not(hidden: true).count).to eq 7
    expect(Query.count).to eq 25
    expect(Projects::Status.count).to eq 2
    expect(Role.where(type: 'Role').count).to eq 5
    expect(GlobalRole.count).to eq 1

    perform_enqueued_jobs

    expect(ActionMailer::Base.deliveries)
      .to be_empty
  end
end
