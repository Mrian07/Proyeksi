

require 'spec_helper'

describe ::Sessions::UserSession do
  subject { described_class.new session_id: 'foo' }

  describe '#save' do
    it 'can not save' do
      expect { subject.save }.to raise_error(ActiveRecord::ReadOnlyRecord)
      expect { subject.save! }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end
  end

  describe '#update' do
    let(:session) { FactoryBot.create :user_session }
    subject { described_class.find_by(session_id: session.session_id) }

    it 'can not update' do
      expect { subject.save }.to raise_error(ActiveRecord::ReadOnlyRecord)
      expect { subject.save! }.to raise_error(ActiveRecord::ReadOnlyRecord)

      expect { subject.update(session_id: 'foo') }.to raise_error(ActiveRecord::ReadOnlyRecord)
      expect { subject.update!(session_id: 'foo') }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end
  end

  describe '#destroy' do
    let(:sessions) { FactoryBot.create :user_session }

    it 'can not destroy' do
      expect { subject.destroy }.to raise_error(ActiveRecord::ReadOnlyRecord)
      expect { subject.destroy! }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end
  end

  describe '.for_user' do
    let(:user) { FactoryBot.create :user }
    let!(:sessions) { FactoryBot.create_list :user_session, 2, user: user }

    subject { described_class.for_user(user) }

    it 'can find and delete, but not destroy those sessions' do
      expect(subject.pluck(:session_id)).to match_array(sessions.map(&:session_id))

      expect { subject.destroy_all }.to raise_error(ActiveRecord::ReadOnlyRecord)

      expect { subject.delete_all }.not_to raise_error

      expect(described_class.for_user(user).count).to eq 0
    end
  end

  describe '.non_user' do
    let!(:session) { FactoryBot.create :user_session, user: nil }

    subject { described_class.non_user }

    it 'can find those sessions' do
      expect(subject.pluck(:session_id)).to contain_exactly(session.session_id)
    end
  end
end
