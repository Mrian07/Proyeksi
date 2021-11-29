

require 'spec_helper'

describe ::API::V3::UpdateQueryFromV3ParamsService,
         type: :model do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:query) { FactoryBot.build_stubbed(:query) }

  let(:params) { double('params') }
  let(:parsed_params) { double('parsed_params') }

  let(:mock_parse_query_service) do
    mock = double('ParseQueryParamsService')

    allow(mock)
      .to receive(:call)
      .with(params)
      .and_return(mock_parse_query_service_response)

    mock
  end

  let(:mock_parse_query_service_response) do
    ServiceResult.new(success: mock_parse_query_service_success,
                      errors: mock_parse_query_service_errors,
                      result: mock_parse_query_service_result)
  end

  let(:mock_parse_query_service_success) { true }
  let(:mock_parse_query_service_errors) { nil }
  let(:mock_parse_query_service_result) { parsed_params }

  let(:mock_update_query_service) do
    mock = double('UpdateQueryFromParamsService')

    allow(mock)
      .to receive(:call)
      .with(parsed_params, valid_subset: false)
      .and_return(mock_update_query_service_response)

    mock
  end

  let(:mock_update_query_service_response) do
    ServiceResult.new(success: mock_update_query_service_success,
                      errors: mock_update_query_service_errors,
                      result: mock_update_query_service_result)
  end

  let(:mock_update_query_service_success) { true }
  let(:mock_update_query_service_errors) { nil }
  let(:mock_update_query_service_result) { query }

  let(:instance) { described_class.new(query, user) }

  before do
    allow(UpdateQueryFromParamsService)
      .to receive(:new)
      .with(query, user)
      .and_return(mock_update_query_service)
    allow(::API::V3::ParseQueryParamsService)
      .to receive(:new)
      .with(no_args)
      .and_return(mock_parse_query_service)
  end

  describe '#call' do
    subject { instance.call(params) }

    it 'returns the update result' do
      is_expected
        .to eql(mock_update_query_service_response)
    end

    context 'when parsing fails' do
      let(:mock_parse_query_service_success) { false }
      let(:mock_parse_query_service_errors) { double 'error' }
      let(:mock_parse_query_service_result) { nil }

      it 'returns the parse result' do
        is_expected
          .to eql(mock_parse_query_service_response)
      end
    end
  end
end
