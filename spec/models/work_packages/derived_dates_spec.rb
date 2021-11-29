

require 'spec_helper'

describe WorkPackage, 'derived dates', type: :model do
  let(:work_package) do
    FactoryBot.create(:work_package)
  end
  let(:child_work_package) do
    FactoryBot.create(:work_package,
                      project: work_package.project,
                      start_date: child_start_date,
                      due_date: child_due_date,
                      parent: work_package)
  end
  let(:child_work_package_in_other_project) do
    FactoryBot.create(:work_package,
                      start_date: other_child_start_date,
                      due_date: other_child_due_date,
                      parent: work_package)
  end
  let(:child_start_date) { Date.today - 4.days }
  let(:child_due_date) { Date.today + 6.days }
  let(:other_child_start_date) { Date.today + 4.days }
  let(:other_child_due_date) { Date.today + 10.days }

  let(:work_packages) { [work_package, child_work_package, child_work_package_in_other_project] }

  let(:role) do
    FactoryBot.build(:role,
                     permissions: %i[view_work_packages])
  end
  let(:user) do
    FactoryBot.create(:user,
                     member_in_project: work_package.project,
                     member_through_role: role)
  end

  before do
    login_as user
    work_packages
  end

  shared_examples_for 'derived dates' do
    context 'with all dates being set' do
      it 'the derived_start_date is the minimum of both start and due date' do
        expect(subject.derived_start_date).to eql child_start_date
      end

      it 'the derived_due_date is the maximum of both start and due date' do
        expect(subject.derived_due_date).to eql other_child_due_date
      end
    end

    context 'with the due dates being minimal (start date being nil)' do
      let(:child_start_date) { nil }
      let(:other_child_start_date) { nil }

      it 'the derived_start_date is the minimum of the due dates' do
        expect(subject.derived_start_date).to eql child_due_date
      end

      it 'the derived_due_date is the maximum of the due dates' do
        expect(subject.derived_due_date).to eql other_child_due_date
      end
    end

    context 'with the start date being maximum (due date being nil)' do
      let(:child_due_date) { nil }
      let(:other_child_due_date) { nil }

      it 'the derived_start_date is the minimum of the start dates' do
        expect(subject.derived_start_date).to eql child_start_date
      end

      it 'has the derived_due_date is the maximum of the start dates' do
        expect(subject.derived_due_date).to eql other_child_start_date
      end
    end

    context 'with child dates being nil' do
      let(:child_start_date) { nil }
      let(:child_due_date) { nil }
      let(:other_child_start_date) { nil }
      let(:other_child_due_date) { nil }

      it 'is nil' do
        expect(subject.derived_start_date).to be_nil
      end
    end

    context 'without children' do
      let(:work_packages) { [work_package] }

      it 'is nil' do
        expect(subject.derived_start_date).to be_nil
      end
    end
  end

  context 'for a work_package loaded individually' do
    subject { work_package }

    it_behaves_like 'derived dates'
  end

  context 'for a work package that had derived dates loaded' do
    subject { WorkPackage.include_derived_dates.first }

    it_behaves_like 'derived dates'
  end

  context 'for an unpersisted work_package' do
    let(:work_package) { WorkPackage.new }
    let(:work_packages) { [] }

    subject { work_package }

    it 'the derived_start_date is nil' do
      expect(subject.derived_start_date).to be_nil
    end

    it 'the derived_due_date is nil' do
      expect(subject.derived_due_date).to be_nil
    end
  end
end
