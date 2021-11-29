

require 'spec_helper'

describe ::API::V3::WorkPackages::Schema::SpecificWorkPackageSchema do
  let(:project) { FactoryBot.build(:project) }
  let(:type) { FactoryBot.build(:type) }
  let(:work_package) do
    FactoryBot.build(:work_package,
                     project: project,
                     type: type)
  end
  let(:current_user) do
    FactoryBot.build_stubbed(:user).tap do |u|
      allow(u)
        .to receive(:allowed_to?)
        .and_return(true)
    end
  end

  shared_examples_for 'with parent which is a BACKLOGS type' do |writable|
    let(:parent) { FactoryBot.create(:work_package, type: type_task) }

    before do
      work_package.parent_id = parent.id
      work_package.save!
    end

    it "is #{'not' unless writable} writable" do
      expect(subject.writable?(:version)).to eql(writable)
    end
  end

  shared_examples_for 'with parent which is not a BACKLOGS type' do
    let(:parent) { FactoryBot.create(:work_package, type: type_feature) }

    before do
      work_package.parent_id = parent.id
      work_package.save!
    end

    it "is writable" do
      expect(subject.writable?(:version)).to eql(true)
    end
  end

  before do
    login_as(current_user)
  end

  describe '#remaining_time_writable?' do
    subject { described_class.new(work_package: work_package) }

    context 'work_package is a leaf' do
      before do
        allow(work_package).to receive(:leaf?).and_return(true)
      end

      it 'is writable' do
        expect(subject.writable?(:remaining_time)).to eql(true)
      end
    end

    context 'work_package is no leaf' do
      before do
        allow(work_package).to receive(:leaf?).and_return(false)
      end

      it 'is not writable' do
        expect(subject.writable?(:remaining_time)).to eql(false)
      end
    end
  end

  describe '#version_writable?' do
    subject { described_class.new(work_package: work_package) }
    let(:type_task) { FactoryBot.create(:type_task) }
    let(:type_feature) { FactoryBot.create(:type_feature) }

    before do
      allow(WorkPackage).to receive(:backlogs_types).and_return([type_task.id])
      allow(work_package).to receive(:backlogs_enabled?).and_return(true)
    end

    describe 'work_package is a task' do
      before do
        allow(work_package)
          .to receive(:is_task?)
          .and_return(true)
      end

      it_behaves_like 'with parent which is a BACKLOGS type', false
      it_behaves_like 'with parent which is not a BACKLOGS type'
    end

    describe 'work_package is no task' do
      before do
        allow(work_package)
          .to receive(:is_task?)
          .and_return(false)
      end

      it_behaves_like 'with parent which is a BACKLOGS type', true
      it_behaves_like 'with parent which is not a BACKLOGS type'
    end
  end
end
