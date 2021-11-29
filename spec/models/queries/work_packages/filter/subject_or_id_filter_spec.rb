

require 'spec_helper'

describe Queries::WorkPackages::Filter::SubjectOrIdFilter, type: :model do
  let(:value) { 'bogus' }
  let(:operator) { '**' }
  let(:subject) { 'Some subject' }
  let(:work_package) { FactoryBot.create(:work_package, subject: subject) }
  let(:current_user) { FactoryBot.create(:user, member_in_project: work_package.project) }
  let(:query) { FactoryBot.build_stubbed(:global_query, user: current_user) }
  let(:instance) do
    described_class.create!(name: :search, context: query, operator: operator, values: [value])
  end

  before do
    login_as current_user
  end

  it 'finds in subject' do
    instance.values = ['Some subject']
    expect(WorkPackage.eager_load(instance.includes).where(instance.where))
      .to match_array [work_package]
  end

  it 'finds in ID' do
    instance.values = [work_package.id.to_s]
    expect(WorkPackage.eager_load(instance.includes).where(instance.where))
      .to match_array [work_package]
  end
end
