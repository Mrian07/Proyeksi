

require 'spec_helper'
require 'rack/test'

describe 'API v3 Relation resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:project) { FactoryBot.create(:project_with_types) }
  let(:current_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let(:permissions) { [] }
  let(:role) { FactoryBot.create(:role, permissions: permissions) }

  let(:work_package) do
    FactoryBot.create(:work_package,
                      project: project,
                      type: project.types.first)
  end
  let(:visible_work_package) do
    FactoryBot.create(:work_package,
                      project: project,
                      type: project.types.first)
  end
  let(:invisible_work_package) do
    # will be inside another project
    FactoryBot.create(:work_package)
  end
  let(:visible_relation) do
    FactoryBot.create(:relation,
                      from: work_package,
                      to: visible_work_package)
  end
  let(:invisible_relation) do
    FactoryBot.create(:relation,
                      from: work_package,
                      to: invisible_work_package)
  end

  before do
    allow(User).to receive(:current).and_return current_user
  end

  subject(:response) { last_response }

  describe '#get' do
    let(:path) { api_v3_paths.work_package_relations(work_package.id) }

    context 'when having the view_work_packages permission' do
      let(:permissions) { [:view_work_packages] }

      before do
        visible_relation
        invisible_relation

        get path
      end

      it_behaves_like 'API V3 collection response', 1, 1, 'Relation'
    end

    context 'when not having view_work_packages' do
      let(:permissions) { [] }

      before do
        get path
      end

      it_behaves_like 'not found',
                      I18n.t('api_v3.errors.not_found.work_package')
    end
  end
end
