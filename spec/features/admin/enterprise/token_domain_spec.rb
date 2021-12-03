

require 'spec_helper'

describe 'Enterprise Edition token domain', type: :feature, js: true do
  let(:current_user) { FactoryBot.create :admin }
  let(:ee_token) { File.read(Rails.root.join("spec/fixtures/ee_tokens/v2_1_user_localhost_3001.token")) }

  before do
    allow(User).to receive(:current).and_return current_user
  end

  shared_examples 'uploading a token' do
    before do
      visit '/admin/enterprise'

      fill_in "enterprise_token[encoded_token]", with: ee_token

      click_on "Save"
    end
  end

  describe 'initial upload' do
    context 'with correct domain', with_settings: { host_name: 'localhost:3001' } do
      it_behaves_like 'uploading a token' do
        it 'saves the token' do
          expect(body).to have_text 'Successful update.'
        end

        it 'shows the token info' do
          expect(body).to have_text 'operations@proyeksiapp.com'
        end
      end
    end

    context 'with incorrect domain', with_settings: { host_name: 'localhost:3000' } do
      it_behaves_like 'uploading a token' do
        it "shows an invalid domain error" do
          expect(body).to have_text "Domain is invalid."
        end
      end
    end
  end

  context 'with an active token', with_settings: { host_name: 'localhost:3001' } do
    before do
      allow(EnterpriseToken).to receive(:current).and_return(EnterpriseToken.new(encoded_token: ee_token))

      visit '/admin/enterprise'
    end

    shared_examples 'replacing a token' do
      let(:new_token) { raise 'define me!' }

      before do
        click_on "Replace your current support token"

        fill_in "enterprise_token[encoded_token]", with: new_token

        click_on "Save"
      end
    end

    it 'shows the current token info' do
      expect(body).to have_text 'operations@proyeksiapp.com'
    end

    describe 'replacing the token' do
      context 'with correct domain' do
        it_behaves_like 'replacing a token' do
          let(:new_token) { ee_token }

          it 'updates the token' do
            expect(body).to have_text 'Successful update.'
          end
        end
      end

      context 'with incorrect domain' do
        it_behaves_like 'replacing a token' do
          let(:new_token) { File.read(Rails.root.join("spec/fixtures/ee_tokens/v2_1_user_localhost_3000.token")) }

          it 'shows an invalid domain error' do
            expect(body).to have_text 'Domain is invalid.'
          end

          it "shows the new token's info" do
            expect(body).to have_text 'localhost:3000'
          end

          it "but doesn't save the new token" do
            visit '/admin/enterprise'

            expect(body).to have_text 'localhost:3001'
          end
        end
      end
    end
  end
end
