

require 'spec_helper'

describe WorkPackage, type: :model do
  describe '#overdue' do
    let(:work_package) do
      FactoryBot.create(:work_package,
                        due_date: due_date)
    end

    shared_examples_for 'overdue' do
      subject { work_package.overdue? }

      it { is_expected.to be_truthy }
    end

    shared_examples_for 'on time' do
      subject { work_package.overdue? }

      it { is_expected.to be_falsey }
    end

    context 'one day ago' do
      let(:due_date) { 1.day.ago.to_date }

      it_behaves_like 'overdue'
    end

    context 'today' do
      let(:due_date) { Date.today.to_date }

      it_behaves_like 'on time'
    end

    context 'next day' do
      let(:due_date) { 1.day.from_now.to_date }

      it_behaves_like 'on time'
    end

    context 'no finish date' do
      let(:due_date) { nil }

      it_behaves_like 'on time'
    end

    context 'status closed' do
      let(:due_date) { 1.day.ago.to_date }
      let(:status) do
        FactoryBot.create(:status,
                          is_closed: true)
      end

      before do
        work_package.status = status
      end

      it_behaves_like 'on time'
    end
  end

  describe '#behind_schedule?' do
    let(:work_package) do
      FactoryBot.create(:work_package,
                        start_date: start_date,
                        due_date: due_date,
                        done_ratio: done_ratio)
    end

    shared_examples_for 'behind schedule' do
      subject { work_package.behind_schedule? }

      it { is_expected.to be_truthy }
    end

    shared_examples_for 'in schedule' do
      subject { work_package.behind_schedule? }

      it { is_expected.to be_falsey }
    end

    context 'no start date' do
      let(:start_date) { nil }
      let(:due_date) { 1.day.from_now.to_date }
      let(:done_ratio) { 0 }

      it_behaves_like 'in schedule'
    end

    context 'no end date' do
      let(:start_date) { 1.day.from_now.to_date }
      let(:due_date) { nil }
      let(:done_ratio) { 0 }

      it_behaves_like 'in schedule'
    end

    context "more done than it's calendar time" do
      let(:start_date) { 50.day.ago.to_date }
      let(:due_date) { 50.day.from_now.to_date }
      let(:done_ratio) { 90 }

      it_behaves_like 'in schedule'
    end

    context 'not started' do
      let(:start_date) { 1.day.ago.to_date }
      let(:due_date) { 1.day.from_now.to_date }
      let(:done_ratio) { 0 }

      it_behaves_like 'behind schedule'
    end

    context "more done than it's calendar time" do
      let(:start_date) { 100.day.ago.to_date }
      let(:due_date) { Date.today }
      let(:done_ratio) { 90 }

      it_behaves_like 'behind schedule'
    end
  end
end
