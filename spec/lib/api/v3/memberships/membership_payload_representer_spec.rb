

require 'spec_helper'

describe ::API::V3::Memberships::MembershipPayloadRepresenter do
  let(:membership) { FactoryBot.build_stubbed(:member) }

  current_user { FactoryBot.build_stubbed(:user) }

  describe 'generation' do
    subject(:json) { representer.to_json }

    describe '_meta' do
      describe 'notificationMessage' do
        let(:meta) { OpenStruct.new notifiation_message: 'Come to the dark side' }
        let(:representer) do
          described_class.create(membership,
                                 meta: meta,
                                 current_user: current_user)
        end

        it_behaves_like 'formattable property', :'_meta/notificationMessage' do
          let(:value) { meta.notification_message }
        end
      end
    end
  end

  describe 'parsing' do
    subject(:parsed) { representer.from_hash parsed_hash }

    let(:representer) do
      described_class.create(OpenStruct.new,
                             meta: OpenStruct.new,
                             current_user: current_user)
    end

    describe '_meta' do
      context 'with meta set' do
        let(:parsed_hash) do
          {
            '_meta' => {
              'notificationMessage' => {
                "raw" => 'Come to the dark side'
              }
            }
          }
        end

        it 'sets the parsed message' do
          expect(parsed.meta.notification_message)
            .to eql 'Come to the dark side'
        end
      end
    end
  end
end
