

require 'spec_helper'
require 'rack/test'

describe 'API v3 Revisions by work package resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper
  include FileHelpers

  let(:current_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let(:project) { FactoryBot.create(:project, public: false) }
  let(:role) { FactoryBot.create(:role, permissions: permissions) }
  let(:permissions) { %i[view_work_packages view_changesets] }
  let(:repository) { FactoryBot.create(:repository_subversion, project: project) }
  let(:work_package) { FactoryBot.create(:work_package, author: current_user, project: project) }
  let(:revisions) { [] }

  subject(:response) { last_response }

  before do
    allow(User).to receive(:current).and_return current_user
  end

  describe '#get' do
    let(:get_path) { api_v3_paths.work_package_revisions work_package.id }

    before do
      revisions.each { |rev| rev.save! }
      get get_path
    end

    it 'should respond with 200' do
      expect(subject.status).to eq(200)
    end

    it_behaves_like 'API V3 collection response', 0, 0, 'Revision'

    context 'with existing revisions' do
      let(:revisions) do
        FactoryBot.build_list(:changeset,
                              5,
                              comments: "This commit references ##{work_package.id}",
                              repository: repository)
      end

      it_behaves_like 'API V3 collection response', 5, 5, 'Revision'

      context 'user unauthorized to view revisions' do
        let(:permissions) { [:view_work_packages] }

        it_behaves_like 'API V3 collection response', 0, 0, 'Revision'
      end
    end

    context 'user unauthorized to view work package' do
      let(:current_user) { FactoryBot.create(:user) }

      it 'should respond with 404' do
        expect(subject.status).to eq(404)
      end
    end

    describe 'revisions linked from another project' do
      let(:subproject) { FactoryBot.create(:project, parent: project) }
      let(:repository) { FactoryBot.create(:repository_subversion, project: subproject) }
      let!(:revisions) do
        FactoryBot.build_list(:changeset,
                              2,
                              comments: "This commit references ##{work_package.id}",
                              repository: repository)
      end

      context 'with permissions in subproject' do
        let(:current_user) do
          FactoryBot.create(:user,
                            member_in_projects: [project, subproject],
                            member_through_role: role)
        end

        it_behaves_like 'API V3 collection response', 2, 2, 'Revision'
      end

      context 'with no permission in subproject' do
        it_behaves_like 'API V3 collection response', 0, 0, 'Revision'
      end
    end
  end
end
