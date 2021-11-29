

require 'spec_helper'

describe ::API::V3::Statuses::StatusCollectionRepresenter do
  include API::V3::Utilities::PathHelper

  let(:statuses) { FactoryBot.build_list(:status, 3) }
  let(:representer) do
    described_class.new(statuses, self_link: api_v3_paths.statuses, current_user: double('current_user'))
  end

  context 'generation' do
    subject(:collection) { representer.to_json }

    it_behaves_like 'unpaginated APIv3 collection', 3, 'statuses', 'Status'
  end
end
