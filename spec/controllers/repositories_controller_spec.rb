#-- encoding: UTF-8



require 'spec_helper'

describe RepositoriesController, type: :controller do
  let(:project) do
    project = FactoryBot.create(:project)
    allow(Project).to receive(:find).and_return(project)
    project
  end
  let(:user) do
    FactoryBot.create(:user, member_in_project: project,
                             member_through_role: role)
  end
  let(:role) { FactoryBot.create(:role, permissions: []) }
  let (:url) { 'file:///tmp/something/does/not/exist.svn' }

  let(:repository) do
    allow(Setting).to receive(:enabled_scm).and_return(['subversion'])
    repo = FactoryBot.build_stubbed(:repository_subversion,
                                    scm_type: 'local',
                                    url: url,
                                    project: project)
    allow(repo).to receive(:default_branch).and_return('master')
    allow(repo).to receive(:branches).and_return(['master'])
    allow(repo).to receive(:save).and_return(true)

    repo
  end

  before do
    login_as(user)
    allow(project).to receive(:repository).and_return(repository)
  end

  describe 'manages the repository' do
    let(:role) { FactoryBot.create(:role, permissions: [:manage_repository]) }

    before do
      # authorization checked in spec/permissions/manage_repositories_spec.rb
      allow(controller).to receive(:authorize).and_return(true)
    end

    context 'with #destroy' do
      before do
        allow(repository).to receive(:destroy).and_return(true)
        delete :destroy, params: { project_id: project.id }, xhr: true
      end

      it 'redirects to settings' do
        expect(response).to redirect_to project_settings_repository_path(project.identifier)
      end
    end

    context 'with #update' do
      before do
        put :update, params: { project_id: project.id }, xhr: true
      end

      it 'redirects to settings' do
        expect(response).to redirect_to project_settings_repository_path(project.identifier)
      end
    end

    context 'with #create' do
      before do
        post :create,
             params: {
               project_id: project.id,
               scm_vendor: 'subversion',
               scm_type: 'local',
               url: 'file:///tmp/repo.svn/'
             }
      end

      it 'redirects to settings' do
        expect(response).to redirect_to project_settings_repository_path(project.identifier)
      end
    end
  end

  describe 'with empty repository' do
    let(:role) { FactoryBot.create(:role, permissions: [:browse_repository]) }

    before do
      allow(repository.scm)
        .to receive(:check_availability!)
        .and_raise(OpenProject::SCM::Exceptions::SCMEmpty)
    end

    context 'with #show' do
      before do
        get :show, params: { project_id: project.identifier }
      end
      it 'renders an empty warning view' do
        expect(response).to render_template 'repositories/empty'
        expect(response.code).to eq('200')
      end
    end

    context 'with #show and checkout' do
      render_views

      let(:checkout_hash) do
        {
          'subversion' => { 'enabled' => '1',
                            'text' => 'foo',
                            'base_url' => 'http://localhost' }
        }
      end

      before do
        allow(Setting).to receive(:repository_checkout_data).and_return(checkout_hash)
        get :show, params: { project_id: project.identifier }
      end

      it 'renders an empty warning view' do
        expect(response).to render_template 'repositories/empty'
        expect(response).to render_template partial: 'repositories/_checkout_instructions'
        expect(response.code).to eq('200')
      end
    end
  end

  describe 'with subversion repository' do
    with_subversion_repository do |repo_dir|
      let(:root_url) { repo_dir }
      let(:url) { "file://#{root_url}" }

      let(:repository) do
        FactoryBot.create(:repository_subversion, project: project, url: url, root_url: url)
      end

      describe 'commits per author graph' do
        before do
          get :graph, params: { project_id: project.identifier, graph: 'commits_per_author' }
        end

        context 'requested by an authorized user' do
          let(:role) do
            FactoryBot.create(:role, permissions: %i[browse_repository
                                                     view_commit_author_statistics])
          end

          it 'should be successful' do
            expect(response).to be_successful
          end

          it 'should have the right content type' do
            expect(response.content_type).to eq('image/svg+xml')
          end
        end

        context 'requested by an unauthorized user' do
          let(:role) { FactoryBot.create(:role, permissions: [:browse_repository]) }

          it 'should return 403' do
            expect(response.code).to eq('403')
          end
        end
      end

      describe 'committers' do
        let(:role) { FactoryBot.create(:role, permissions: [:manage_repository]) }

        describe '#get' do
          before do
            get :committers, params: { project_id: project.id }
          end

          it 'should be successful' do
            expect(response).to be_successful
            expect(response).to render_template 'repositories/committers'
          end
        end

        describe '#post' do
          before do
            repository.fetch_changesets
            post :committers, params: { project_id: project.id, committers: { '0' => ['oliver', user.id] },
                                        commit: 'Update' }
          end

          it 'should be successful' do
            expect(response).to redirect_to committers_project_repository_path(project)
            expect(repository.committers).to include(['oliver', user.id])
          end
        end
      end

      describe 'stats' do
        before do
          get :stats, params: { project_id: project.identifier }
        end

        describe 'requested by a user with view_commit_author_statistics permission' do
          let(:role) do
            FactoryBot.create(:role, permissions: %i[browse_repository
                                                     view_commit_author_statistics])
          end

          it 'show the commits per author graph' do
            expect(assigns(:show_commits_per_author)).to eq(true)
          end
        end

        describe 'requested by a user without view_commit_author_statistics permission' do
          let(:role) { FactoryBot.create(:role, permissions: [:browse_repository]) }

          it 'should NOT show the commits per author graph' do
            expect(assigns(:show_commits_per_author)).to eq(false)
          end
        end
      end

      shared_examples 'renders the repository title' do |active_breadcrumb|
        it do
          expect(response).to be_successful
          expect(response.body).to have_selector('.repository-breadcrumbs', text: active_breadcrumb)
        end
      end

      describe 'show' do
        render_views
        let(:role) { FactoryBot.create(:role, permissions: [:browse_repository]) }

        before do
          get :show, params: { project_id: project.identifier, repo_path: path }
        end

        context 'with brackets' do
          let(:path) { 'subversion_test/[folder_with_brackets]' }
          it_behaves_like 'renders the repository title', '[folder_with_brackets]'
        end

        context 'with unicode' do
          let(:path) { 'Föbar/äm/Sägepütz!%5D§' }
          it_behaves_like 'renders the repository title', 'Sägepütz!%5D§'
        end
      end

      describe 'changes' do
        render_views
        let(:role) { FactoryBot.create(:role, permissions: [:browse_repository]) }

        before do
          get :changes, params: { project_id: project.identifier, repo_path: path }
          expect(response).to be_successful
        end

        context 'with brackets' do
          let(:path) { 'subversion_test/[folder_with_brackets]' }
          it_behaves_like 'renders the repository title', '[folder_with_brackets]'
        end

        context 'with unicode' do
          let(:path) { 'Föbar/äm' }
          it_behaves_like 'renders the repository title', 'äm'
        end
      end

      describe 'checkout path' do
        render_views

        let(:role) { FactoryBot.create(:role, permissions: [:browse_repository]) }
        let(:checkout_hash) do
          {
            'subversion' => { 'enabled' => '1',
                              'text' => 'foo',
                              'base_url' => 'http://localhost' }
          }
        end

        before do
          allow(Setting).to receive(:repository_checkout_data).and_return(checkout_hash)
          get :show, params: { project_id: project.identifier, repo_path: 'subversion_test' }
        end

        it 'renders an empty warning view' do
          expected_path = "http://localhost/#{project.identifier}/subversion_test"

          expect(response.code).to eq('200')
          expect(response).to render_template partial: 'repositories/_checkout_instructions'
          expect(response.body).to have_selector("#repository-checkout-url[value='#{expected_path}']")
        end
      end
    end
  end

  describe 'when not being logged in' do
    let(:anonymous) { FactoryBot.build_stubbed(:anonymous) }

    before do
      login_as(anonymous)
    end

    describe '#show' do
      it 'redirects to login while preserving the path' do
        params = { repo_path: 'aDir/within/aDir', rev: '42', project_id: project.id }
        get :show, params: params

        expect(response)
          .to redirect_to signin_path(back_url: show_revisions_path_project_repository_url(params))
      end
    end
  end
end
