

require 'spec_helper'

describe SystemUser, type: :model do
  let(:system_user) { User.system }

  describe '#run_given' do
    it 'runs block with SystemUser' do
      before_user = User.current

      system_user.run_given do
        expect(User.current).to eq system_user
        expect(User.current).to be_admin
      end

      expect(User.current).to eq(before_user)
    end
  end
end
