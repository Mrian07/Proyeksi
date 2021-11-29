

require 'spec_helper'

describe 'layouts/admin', type: :view do
  shared_let(:admin) { FactoryBot.create :admin }

  include Redmine::MenuManager::MenuHelper
  helper Redmine::MenuManager::MenuHelper

  before do
    allow(view).to receive(:current_menu_item).and_return('overview')
    allow(view).to receive(:default_breadcrumb)
    allow(controller).to receive(:default_search_scope)

    parent_menu_item = Object.new
    allow(view).to receive(:admin_first_level_menu_entry).and_return parent_menu_item
    allow(parent_menu_item).to receive(:name).and_return :root

    allow(User).to receive(:current).and_return admin
    allow(view).to receive(:current_user).and_return admin
    allow(view)
      .to receive(:render_to_string)
  end

  # All password-based authentication is to be hidden and disabled if
  # `disable_password_login` is true. This includes LDAP.
  describe 'LDAP authentication menu entry' do
    context 'with password login enabled' do
      before do
        allow(OpenProject::Configuration).to receive(:disable_password_login?).and_return(false)
        render
      end

      it 'is shown' do
        expect(rendered).to have_selector('a', text: I18n.t('label_ldap_authentication'))
      end
    end

    context 'with password login disabled' do
      before do
        allow(OpenProject::Configuration).to receive(:disable_password_login?).and_return(true)
        render
      end

      it 'is hidden' do
        expect(rendered).not_to have_selector('a', text: I18n.t('label_ldap_authentication'))
      end
    end
  end
end
