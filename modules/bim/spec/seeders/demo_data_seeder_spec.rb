#-- encoding: UTF-8



require 'spec_helper'

describe RootSeeder,
         'BIM edition',
         with_config: { edition: 'bim' },
         with_settings: { journal_aggregation_time_minutes: 0 } do
  it 'create the demo data' do
    expect { described_class.new.do_seed! }.not_to raise_error

    expect(User.not_builtin.where(admin: true).count).to eq 1
    expect(Project.count).to eq 4
    expect(WorkPackage.count).to eq 76
    expect(Wiki.count).to eq 3
    expect(Query.count).to eq 25
    expect(Group.count).to eq 8
    expect(Type.count).to eq 7
    expect(Status.count).to eq 4
    expect(IssuePriority.count).to eq 4
    expect(Projects::Status.count).to eq 4
    expect(Bim::IfcModels::IfcModel.count).to eq 3

    perform_enqueued_jobs

    expect(ActionMailer::Base.deliveries)
      .to be_empty
  end
end
