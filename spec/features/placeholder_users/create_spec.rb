

require 'spec_helper'

describe 'create placeholder users', type: :feature, selenium: true do
  let(:new_placeholder_user_page) { Pages::NewPlaceholderUser.new }

  shared_examples_for 'placeholders creation flow' do
    context 'with enterprise', with_ee: %i[placeholder_users] do
      it 'creates the placeholder user' do
        visit new_placeholder_user_path

        new_placeholder_user_page.fill_in! name: 'UX Designer'


          new_placeholder_user_page.submit!


        expect(page).to have_selector('.flash', text: 'Successful creation.')

        new_placeholder_user = PlaceholderUser.order(Arel.sql('id DESC')).first

        expect(current_path).to eql(edit_placeholder_user_path(new_placeholder_user.id))
      end
    end

    context 'without enterprise' do
      it 'creates the placeholder user' do
        visit new_placeholder_user_path

        new_placeholder_user_page.fill_in! name: 'UX Designer'
        new_placeholder_user_page.submit!

        expect(page).to have_text 'is only available in the ProyeksiApp Enterprise Edition'
      end
    end
  end

  context 'as admin' do
    current_user { FactoryBot.create :admin }

    it_behaves_like 'placeholders creation flow'
  end

  context 'as user with global permission' do
    current_user { FactoryBot.create :user, global_permission: %i[manage_placeholder_user] }

    it_behaves_like 'placeholders creation flow'
  end

  context 'as user without global permission' do
    current_user { FactoryBot.create :user }

    it 'returns an error' do
      visit new_placeholder_user_path
      expect(page).to have_text 'You are not authorized to access this page.'
    end
  end
end
