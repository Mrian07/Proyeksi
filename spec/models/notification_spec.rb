#-- encoding: UTF-8


require 'spec_helper'

describe Notification,
         type: :model do
  describe '.save' do
    context 'for a non existing journal (e.g. because it has been deleted)' do
      let(:notification) { FactoryBot.build(:notification) }

      it 'raises an error' do
        notification.journal_id = 99999
        expect { notification.save }
          .to raise_error ActiveRecord::InvalidForeignKey
      end
    end
  end
end
