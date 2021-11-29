

require 'spec_helper'
require_relative '../principals/shared_memberships_examples'

feature 'user memberships through user page', type: :feature, js: true do
  include_context 'principal membership management context'

  shared_let(:principal) { FactoryBot.create :user, firstname: 'Foobar', lastname: 'Blabla' }
  shared_let(:principal_page) { Pages::Admin::IndividualPrincipals::Edit.new(principal) }

  context 'as admin' do
    current_user { FactoryBot.create :admin }

    it_behaves_like 'principal membership management flows'
  end

  it_behaves_like 'global user principal membership management flows', :manage_user
end
