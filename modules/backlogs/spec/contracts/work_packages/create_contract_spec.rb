

require 'spec_helper'

describe WorkPackages::CreateContract do
  let(:work_package) do
    WorkPackage.new FactoryBot.attributes_for(:stubbed_work_package, author: other_user, project: project)
  end
  let(:other_user) { FactoryBot.build_stubbed(:user) }
  include_context 'user with stubbed permissions'
  let (:project) { FactoryBot.build_stubbed(:project) }
  let(:permissions) do
    %i[
      view_work_packages
      add_work_packages
    ]
  end
  let(:changed_values) { [] }

  subject(:contract) { described_class.new(work_package, user) }

  before do
    allow(work_package).to receive(:changed).and_return(changed_values)
  end

  describe 'story points' do
    before do
      contract.validate
    end

    context 'has not changed' do
      it('is valid') { expect(contract.errors.symbols_for(:story_points)).to be_empty }
    end

    context 'has changed' do
      let(:changed_values) { ['story_points'] }

      it('is valid') { expect(contract.errors.symbols_for(:story_points)).to be_empty }
    end
  end

  describe 'remaining hours' do
    context 'is no parent' do
      before do
        contract.validate
      end

      context 'has not changed' do
        it('is valid') { expect(contract.errors.symbols_for(:remaining_hours)).to be_empty }
      end

      context 'has changed' do
        let(:changed_values) { ['remaining_hours'] }

        it('is valid') { expect(contract.errors.symbols_for(:remaining_hours)).to be_empty }
      end
    end
  end
end
