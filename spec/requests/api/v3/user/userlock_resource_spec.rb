

require 'spec_helper'
require 'rack/test'

describe 'API v3 UserLock resource', type: :request, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:user) { FactoryBot.create(:user, status: User.statuses[:active]) }
  let(:model) { ::API::V3::Users::UserModel.new(user) }
  let(:representer) { ::API::V3::Users::UserRepresenter.new(model) }
  let(:lock_path) { api_v3_paths.user_lock user.id }
  subject(:response) { last_response }

  describe '#post' do
    before do
      allow(User).to receive(:current).and_return current_user
      post lock_path
      # lock manually
      user.lock
    end

    # Locking is only available for admins
    context 'when logged in as admin' do
      let(:current_user) { FactoryBot.build_stubbed(:admin) }

      context 'user account can be locked' do
        it 'should respond with 200' do
          expect(subject.status).to eq(200)
        end

        it 'should respond with an updated lock status in the user model' do
          expect(parse_json(subject.body, 'status')).to eq 'locked'
        end
      end

      context 'user account is incompatible' do
        let(:user) do
          FactoryBot.create(:user, status: User.statuses[:registered])
        end
        it 'should fail for invalid transitions' do
          expect(subject.status).to eq(400)
        end
      end
    end

    context 'requesting nonexistent user' do
      let(:lock_path) { api_v3_paths.user_lock 9999 }
      it_behaves_like 'not found'
    end

    context 'non-admin user' do
      it 'should respond with 403' do
        expect(subject.status).to eq(403)
      end
    end
  end

  describe '#delete' do
    before do
      allow(User).to receive(:current).and_return current_user
      delete lock_path
      # unlock manually
      user.activate
    end

    # Unlocking is only available for admins
    context 'when logged in as admin' do
      let(:current_user) { FactoryBot.build_stubbed(:admin) }

      context 'user account can be unlocked' do
        it 'should respond with 200' do
          expect(subject.status).to eq(200)
        end

        it 'should respond with an updated lock status in the user model' do
          expect(parse_json(subject.body, 'status')).to eq 'active'
        end
      end

      context 'user account is incompatible' do
        let(:user) do
          FactoryBot.create(:user, status: User.statuses[:registered])
        end
        it 'should fail for invalid transitions' do
          expect(subject.status).to eq(400)
        end
      end
    end

    context 'non-admin user' do
      it 'should respond with 403' do
        expect(subject.status).to eq(403)
      end
    end
  end
end
