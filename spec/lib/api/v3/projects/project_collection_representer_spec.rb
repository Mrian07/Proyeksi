

require 'spec_helper'

describe ::API::V3::Projects::ProjectCollectionRepresenter do
  shared_let(:projects) { FactoryBot.create_list(:project, 3) }

  let(:self_base_link) { '/api/v3/projects' }
  let(:current_user) { FactoryBot.build(:user) }
  let(:representer) do
    described_class.new Project.all,
                        self_link: self_base_link,
                        current_user: current_user
  end
  let(:total) { 3 }
  let(:page) { 1 }
  let(:page_size) { 30 }
  let(:actual_count) { 3 }
  let(:collection_inner_type) { 'Project' }

  subject { representer.to_json }

  context 'generation' do
    subject(:collection) { representer.to_json }

    it_behaves_like 'offset-paginated APIv3 collection', 3, 'projects', 'Project'
  end

  describe 'representation formats' do
    it_behaves_like 'has a link collection' do
      let(:link) { 'representations' }
      let(:hrefs) do
        [
          {
            'href' => '/projects.csv?offset=1&pageSize=30',
            'identifier' => 'csv',
            'type' => 'text/csv',
            'title' => 'CSV'
          },
          {
            'href' => '/projects.xls?offset=1&pageSize=30',
            'identifier' => 'xls',
            'type' => 'application/vnd.ms-excel',
            'title' => 'XLS'
          }
        ]
      end
    end
  end

  describe '.checked_permissions' do
    it 'lists add_work_packages' do
      expect(described_class.checked_permissions).to match_array([:add_work_packages])
    end
  end
end
