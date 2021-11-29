

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe WorkPackages::UpdateAncestorsService do
  let(:user) { FactoryBot.create :user }

  let(:sibling_remaining_hours) { 7.0 }
  let(:work_package_remaining_hours) { 5.0 }

  let!(:grandparent) do
    FactoryBot.create :work_package
  end
  let!(:parent) do
    FactoryBot.create :work_package,
                      parent: grandparent
  end
  let!(:sibling) do
    FactoryBot.create :work_package,
                      parent: parent,
                      remaining_hours: sibling_remaining_hours
  end

  context 'for a new ancestors' do
    let!(:work_package) do
      FactoryBot.create :work_package,
                        remaining_hours: work_package_remaining_hours,
                        parent: parent
    end

    subject do
      described_class
        .new(user: user,
             work_package: work_package)
        .call(%i(parent))
    end

    before do
      subject
    end

    it 'recalculates the remaining_hours for new parent and grandparent' do
      expect(grandparent.reload.remaining_hours)
        .to eql sibling_remaining_hours + work_package_remaining_hours

      expect(parent.reload.remaining_hours)
        .to eql sibling_remaining_hours + work_package_remaining_hours

      expect(sibling.reload.remaining_hours)
        .to eql sibling_remaining_hours

      expect(work_package.reload.remaining_hours)
        .to eql work_package_remaining_hours
    end
  end

  context 'for the previous ancestors' do
    let!(:work_package) do
      FactoryBot.create :work_package,
                        remaining_hours: work_package_remaining_hours,
                        parent: parent
    end

    subject do
      work_package.parent = nil
      work_package.save!

      described_class
        .new(user: user,
             work_package: work_package)
        .call(%i(parent))
    end

    before do
      subject
    end

    it 'recalculates the remaining_hours for former parent and grandparent' do
      expect(grandparent.reload.remaining_hours)
        .to eql sibling_remaining_hours

      expect(parent.reload.remaining_hours)
        .to eql sibling_remaining_hours

      expect(sibling.reload.remaining_hours)
        .to eql sibling_remaining_hours

      expect(work_package.reload.remaining_hours)
        .to eql work_package_remaining_hours
    end
  end
end
