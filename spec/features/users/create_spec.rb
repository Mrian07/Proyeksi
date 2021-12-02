

require 'spec_helper'

describe 'create users', type: :feature, selenium: true do
  shared_let(:admin) { FactoryBot.create :admin }
  let(:current_user) { admin }
  let!(:auth_source) { FactoryBot.create :dummy_auth_source }
  let(:new_user_page) { Pages::NewUser.new }
  let(:mail) do
    ActionMailer::Base.deliveries.last
  end
  let(:mail_body) { mail.body.parts.first.body.to_s }
  let(:token) { mail_body.scan(/token=(.*)$/).first.first.strip }

  before do
    allow(User).to receive(:current).and_return current_user
  end

  shared_examples_for 'successful user creation' do
    it 'creates the user' do
      expect(page).to have_selector('.flash', text: 'Successful creation.')

      new_user = User.order(Arel.sql('id DESC')).first

      expect(current_path).to eql(edit_user_path(new_user.id))
    end

    it 'sends out an activation email' do
      expect(mail_body).to include 'activate your account'
      expect(token).not_to be_nil
    end
  end

  context 'with internal authentication' do
    before do
      visit new_user_path

      new_user_page.fill_in! first_name: 'bobfirst',
                             last_name: 'boblast',
                             email: 'bob@mail.com'

      perform_enqueued_jobs do
        new_user_page.submit!
      end
    end

    it_behaves_like 'successful user creation' do
      describe 'activation' do
        before do
          allow(User).to receive(:current).and_call_original

          visit "/account/activate?token=#{token}"
        end

        it 'shows the registration form' do
          expect(page).to have_text 'Create a new account'
        end

        it 'registers the user upon submission' do
          fill_in 'user_password', with: 'foobarbaz1'
          fill_in 'user_password_confirmation', with: 'foobarbaz1'

          click_button 'Create'

          # landed on the 'my page'
          expect(page).to have_text 'Welcome, your account has been activated. You are logged in now.'
          expect(page).to have_link 'bobfirst boblast'
        end
      end
    end
  end

  context 'with external authentication', js: true do
    before do
      new_user_page.visit!

      new_user_page.fill_in! first_name: 'bobfirst',
                             last_name: 'boblast',
                             email: 'bob@mail.com',
                             login: 'bob',
                             auth_source: auth_source.name

      perform_enqueued_jobs do
        new_user_page.submit!
      end
    end

    after do
      # Clear session to avoid that the onboarding tour starts
      page.execute_script("window.sessionStorage.clear();")
    end

    it_behaves_like 'successful user creation' do
      describe 'activation', js: true do
        before do
          allow(User).to receive(:current).and_call_original

          visit "/account/activate?token=#{token}"
        end

        it 'shows the login form prompting the user to login' do
          expect(page).to have_text 'Please login as bob to activate your account.'
        end

        it 'registers the user upon submission' do
          # login is already filled with 'bob'
          fill_in 'password', with: 'dummy' # accepted by DummyAuthSource

          click_button 'Sign in'

          expect(page).to have_text 'ProyeksiApp'
          expect(current_path).to eq '/'
          expect(page).to have_link 'bobfirst boblast'
        end
      end
    end
  end

  context 'as global user' do
    shared_let(:global_manage_user) { FactoryBot.create :user, global_permission: :manage_user }
    let(:current_user) { global_manage_user }

    context 'with internal authentication' do
      before do
        visit new_user_path

        new_user_page.fill_in! first_name: 'bobfirst',
                               last_name: 'boblast',
                               email: 'bob@mail.com'

        perform_enqueued_jobs do
          new_user_page.submit!
        end
      end

      it_behaves_like 'successful user creation' do
        describe 'activation' do
          before do
            allow(User).to receive(:current).and_call_original

            visit "/account/activate?token=#{token}"
          end

          it 'shows the registration form' do
            expect(page).to have_text 'Create a new account'
          end

          it 'registers the user upon submission' do
            fill_in 'user_password', with: 'foobarbaz1'
            fill_in 'user_password_confirmation', with: 'foobarbaz1'

            click_button 'Create'

            # landed on the 'my page'
            expect(page).to have_text 'Welcome, your account has been activated. You are logged in now.'
            expect(page).to have_link 'bobfirst boblast'
          end
        end
      end
    end
  end
end
