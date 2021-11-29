#-- encoding: UTF-8


require 'spec_helper'

describe Journal,
         type: :model do
  describe '#journable' do
    it 'raises no error on a new journal without a journable' do
      expect(Journal.new.journable)
        .to be_nil
    end
  end

  describe '#notifications' do
    let(:work_package) { FactoryBot.create(:work_package) }
    let(:journal) { work_package.journals.first }
    let!(:notification) do
      FactoryBot.create(:notification,
                        journal: journal,
                        resource: work_package,
                        project: work_package.project)
    end

    it 'has a notifications association' do
      expect(journal.notifications)
        .to match_array([notification])
    end

    it 'destroys the associated notifications upon journal destruction' do
      expect { journal.destroy }
        .to change(Notification, :count).from(1).to(0)
    end
  end
end
