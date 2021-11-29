

require 'spec_helper'

describe Overviews::OverviewsController, type: :controller do
  let(:permissions) do
    %i(view_project)
  end
  let(:current_user) do
    FactoryBot.build_stubbed(:user).tap do |u|
      allow(u)
        .to receive(:allowed_to?) do |permission, permission_project, _global|
        permission_project == project &&
          (permissions.include?(permission) ||
          [{ controller: 'overviews/overviews', action: 'show' },
           { controller: '/news', action: 'index' }].include?(permission))
      end
    end
  end
  let(:project) do
    FactoryBot.build_stubbed(:project).tap do |p|
      allow(Project)
        .to receive(:find)
        .with(p.id.to_s)
        .and_return(p)
    end
  end

  let(:main_app_routes) do
    Rails.application.routes.url_helpers
  end

  before do
    login_as current_user
  end

  describe '#show' do
    context 'with jump parameter' do
      it 'redirects to active tab' do
        get :show, params: { project_id: project.id, jump: 'news' }

        expect(response)
          .to redirect_to main_app_routes.project_news_index_path(project)
      end

      it 'ignores inactive/unpermitted module' do
        get :show, params: { project_id: project.id, jump: 'work_packages' }

        expect(response)
          .to be_successful
      end

      it 'ignores bogus module' do
        get :show, params: { project_id: project.id, jump: 'foobar' }

        expect(response)
          .to be_successful
      end
    end
  end
end
