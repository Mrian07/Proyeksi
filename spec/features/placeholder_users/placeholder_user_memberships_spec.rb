

require 'spec_helper'
require_relative '../principals/shared_memberships_examples'

feature 'placeholder user memberships through placeholder user page', type: :feature, js: true do
  shared_let(:principal) { FactoryBot.create :placeholder_user, name: 'UX Designer' }
  shared_let(:principal_page) { Pages::Admin::IndividualPrincipals::Edit.new(principal) }

  include_context 'principal membership management context'

  context 'as admin' do
    current_user { FactoryBot.create :admin }

    it_behaves_like 'principal membership management flows'
  end

  it_behaves_like 'global user principal membership management flows', :manage_placeholder_user
end
