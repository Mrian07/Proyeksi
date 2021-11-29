

require 'spec_helper'

describe ::API::V3::Categories::CategoryCollectionRepresenter do
  let(:categories) { FactoryBot.build_list(:category, 3) }
  let(:representer) do
    described_class.new(categories,
                        self_link: '/api/v3/projects/1/categories',
                        current_user: double('current_user'))
  end

  context 'generation' do
    subject(:collection) { representer.to_json }

    it_behaves_like 'unpaginated APIv3 collection', 3, 'projects/1/categories', 'Category'
  end
end
