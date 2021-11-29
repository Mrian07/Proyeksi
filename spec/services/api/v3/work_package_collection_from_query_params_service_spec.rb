

require 'spec_helper'

describe ::API::V3::WorkPackageCollectionFromQueryParamsService,
         type: :model do
  include API::V3::Utilities::PathHelper

  let(:mock_wp_collection_from_query_service) do
    mock = double('WorkPackageCollectionFromQueryService')

    allow(mock)
      .to receive(:call)
      .with(params)
      .and_return(mock_wp_collection_service_response)

    mock
  end

  let(:mock_wp_collection_service_response) do
    ServiceResult.new(success: mock_wp_collection_service_success,
                      errors: mock_wp_collection_service_errors,
                      result: mock_wp_collection_service_result)
  end

  let(:mock_wp_collection_service_success) { true }
  let(:mock_wp_collection_service_errors) { nil }
  let(:mock_wp_collection_service_result) { double('result') }

  let(:query) { FactoryBot.build_stubbed(:query) }
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:user) { FactoryBot.build_stubbed(:user) }

  let(:instance) { described_class.new(user) }

  before do
    stub_const('::API::V3::WorkPackageCollectionFromQueryService',
               mock_wp_collection_from_query_service)

    allow(::API::V3::WorkPackageCollectionFromQueryService)
      .to receive(:new)
      .with(query, user, scope: nil)
      .and_return(mock_wp_collection_from_query_service)
  end

  describe '#call' do
    let(:params) { { project: project } }

    subject { instance.call(params) }

    before do
      allow(Query)
        .to receive(:new_default)
        .with(name: '_', project: project)
        .and_return(query)
    end

    it 'is successful' do
      is_expected
        .to eql(mock_wp_collection_service_response)
    end
  end
end
