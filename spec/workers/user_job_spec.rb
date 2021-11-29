#-- encoding: UTF-8



require 'spec_helper'

describe UserJob do
  let(:test_job) do
    Class.new(::UserJob) do
      def execute(foo:)
        [user.id, User.current.id, user.admin]
      end
    end
  end

  subject do
    test_job.new(user: user, foo: 'foo').perform_now
  end

  describe 'with system user' do
    let(:user) { User.system }

    it 'uses that user' do
      given_user, current_user, admin = subject
      expect(given_user).to eq current_user
      expect(given_user).to eq user.id
      expect(admin).to eq true
    end
  end

  describe 'with a regular user' do
    let(:user) { FactoryBot.build_stubbed :user }

    it 'uses that user' do
      given_user, current_user, admin = subject
      expect(given_user).to eq current_user
      expect(given_user).to eq user.id
      expect(admin).to eq false
    end
  end
end
