

require 'spec_helper'

describe ActivitiesController, type: :controller do
  before :each do
    allow(@controller).to receive(:set_localization)

    admin = FactoryBot.create(:admin)
    allow(User).to receive(:current).and_return admin

    @params = {}
  end

  describe 'index' do
    shared_examples_for 'valid index response' do
      it { expect(response).to be_successful }

      it { expect(response).to render_template 'index' }
    end

    describe 'global' do
      let(:work_package) { FactoryBot.create(:work_package) }
      let!(:journal) do
        FactoryBot.create(:work_package_journal,
                          journable_id: work_package.id,
                          created_at: 3.days.ago.to_date.to_s(:db),
                          version: Journal.maximum(:version) + 1,
                          data: FactoryBot.build(:journal_work_package_journal,
                                                 subject: work_package.subject,
                                                 status_id: work_package.status_id,
                                                 type_id: work_package.type_id,
                                                 project_id: work_package.project_id))
      end

      before { get 'index' }

      it_behaves_like 'valid index response'

      it { expect(assigns(:events_by_day)).not_to be_empty }

      describe 'view' do
        render_views

        it do
          assert_select 'h3',
                        content: /#{3.day.ago.to_date.day}/,
                        sibling: { tag: 'dl',
                                   child: { tag: 'dt',
                                            attributes: { class: /work_package/ },
                                            child: { tag: 'a',
                                                     content: /#{ERB::Util.html_escape(work_package.subject)}/ } } }
        end
      end

      describe 'empty filter selection' do
        before do
          get 'index', params: { event_types: [''] }
        end

        it_behaves_like 'valid index response'

        it { expect(assigns(:events_by_day)).to be_empty }
      end
    end

    describe 'with activated activity module' do
      let(:project) do
        FactoryBot.create(:project,
                          enabled_module_names: %w[activity wiki])
      end

      it 'renders activity' do
        get 'index', params: { project_id: project.id }
        expect(response).to be_successful
        expect(response).to render_template 'index'
      end
    end

    describe 'without activated activity module' do
      let(:project) do
        FactoryBot.create(:project,
                          enabled_module_names: %w[wiki])
      end

      it 'renders 403' do
        get 'index', params: { project_id: project.id }
        expect(response.status).to eq(403)
        expect(response).to render_template 'common/error'
      end
    end

    shared_context 'index with params' do
      let(:session_values) { defined?(session_hash) ? session_hash : {} }

      before { get :index, params: params, session: session_values }
    end

    describe '#atom_feed' do
      let(:user) { FactoryBot.create(:user) }
      let(:project) { FactoryBot.create(:project) }

      context 'work_package' do
        let!(:wp_1) do
          FactoryBot.create(:work_package,
                            project: project,
                            author: user)
        end

        describe 'global' do
          render_views

          before { get 'index', format: 'atom' }

          it do
            assert_select 'entry',
                          child: { tag: 'link',
                                   attributes: { href: Regexp.new("/work_packages/#{wp_1.id}#") } }
          end
        end

        describe 'list' do
          let!(:wp_2) do
            FactoryBot.create(:work_package,
                              project: project,
                              author: user)
          end

          let(:params) do
            { project_id: project.id,
              format: :atom }
          end

          include_context 'index with params'

          it { expect(assigns(:items).count).to eq(2) }

          it { expect(response).to render_template('common/feed') }
        end
      end

      context 'forums' do
        let(:forum) do
          FactoryBot.create(:forum,
                            project: project)
        end
        let!(:message_1) do
          FactoryBot.create(:message,
                            forum: forum)
        end
        let!(:message_2) do
          FactoryBot.create(:message,
                            forum: forum)
        end
        let(:params) do
          { project_id: project.id,
            event_types: [:messages],
            format: :atom }
        end

        include_context 'index with params'

        it { expect(assigns(:items).count).to eq(2) }

        it { expect(response).to render_template('common/feed') }
      end
    end

    describe 'user selection' do
      describe 'first activity request' do
        let(:default_scope) { ['work_packages', 'changesets'] }
        let(:params) { {} }

        include_context 'index with params'

        it { expect(assigns(:activity).scope).to match_array(default_scope) }

        it { expect(session[:activity]).to match_array(default_scope) }
      end

      describe 'subsequent activity requests' do
        let(:scope) { [] }
        let(:params) { {} }
        let(:session_hash) { { activity: [] } }

        include_context 'index with params'

        it { expect(assigns(:activity).scope).to match_array(scope) }

        it { expect(session[:activity]).to match_array(scope) }
      end

      describe 'selection with apply' do
        let(:scope) { [] }
        let(:params) { { event_types: [''] } }

        include_context 'index with params'

        it { expect(assigns(:activity).scope).to match_array(scope) }

        it { expect(session[:activity]).to match_array(scope) }
      end
    end
  end
end
