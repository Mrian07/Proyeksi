

require 'spec_helper'

describe WikiMenuItemsController, type: :controller do
  before do
    User.delete_all
    Role.delete_all

    @project = FactoryBot.create(:project)
    @project.reload # project contains wiki by default

    @params = {}
    @params[:project_id] = @project.id
    page = FactoryBot.create(:wiki_page, wiki: @project.wiki)
    @params[:id] = page.title
  end

  describe 'w/ valid auth' do
    it 'renders the edit action' do
      admin_user = FactoryBot.create(:admin)

      allow(User).to receive(:current).and_return admin_user
      permission_role = FactoryBot.create(:role, name: 'accessgranted', permissions: [:manage_wiki_menu])
      member = FactoryBot.create(:member, principal: admin_user, user: admin_user, project: @project, roles: [permission_role])

      get 'edit', params: @params

      expect(response).to be_successful
    end
  end

  describe 'w/o valid auth' do
    it 'be forbidden' do
      allow(User).to receive(:current).and_return FactoryBot.create(:user)

      get 'edit', params: @params

      expect(response.status).to eq(403) # forbidden
    end
  end
end
