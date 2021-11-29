

require 'spec_helper'

describe ::API::V3::Users::UserRepresenter do
  let(:user) { FactoryBot.build_stubbed(:user, status: 1) }
  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:representer) { described_class.new(user, current_user: current_user) }

  context 'generation' do
    subject(:generated) { representer.to_json }

    describe 'avatar', with_settings: { protocol: 'http' } do
      before do
        allow(Setting).to receive(:plugin_openproject_avatars)
          .and_return(enable_gravatars: true)

        user.mail = 'foo@bar.com'
      end

      it 'should have an url to gravatar if settings permit and mail is set' do
        expect(parse_json(subject, 'avatar')).to start_with('http://gravatar.com/avatar')
      end

      it 'should be blank if gravatar is disabled' do
        allow(Setting)
          .to receive(:plugin_openproject_avatars)
          .and_return(enable_gravatars: false)

        expect(parse_json(subject, 'avatar')).to be_blank
      end

      it 'should be blank if email is missing (e.g. anonymous)' do
        user.mail = nil

        expect(parse_json(subject, 'avatar')).to be_blank
      end
    end
  end
end
