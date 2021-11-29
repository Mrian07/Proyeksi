#-- encoding: UTF-8



require 'spec_helper'

describe Queries::CreateService do
  let(:user) { FactoryBot.build_stubbed(:admin) }
  let(:query) { FactoryBot.build(:query, user: user) }

  let(:instance) { described_class.new(user: user) }
  subject { instance.call(query).result }

  describe 'ordered work packages' do
    let!(:work_package) { FactoryBot.create :work_package }

    before do
      query.ordered_work_packages.build(work_package_id: work_package.id, position: 0)
      query.ordered_work_packages.build(work_package_id: 99999, position: 1)
    end

    it 'removes items for which work packages do not exist' do
      expect(subject).to be_valid
      expect(subject.ordered_work_packages.length).to eq 1
      expect(subject.ordered_work_packages.first.work_package_id).to eq work_package.id
    end
  end
end
