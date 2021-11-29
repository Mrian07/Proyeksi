

require 'spec_helper'

describe ::API::V3::Queries::Operators::QueryOperatorRepresenter do
  include ::API::V3::Utilities::PathHelper

  let(:operator) { Queries::Operators::NotContains }
  let(:representer) { described_class.new(operator) }

  subject { representer.to_json }

  describe 'generation' do
    describe '_links' do
      it_behaves_like 'has a titled link' do
        let(:link) { 'self' }
        let(:href) { api_v3_paths.query_operator operator.to_query }
        let(:title) { I18n.t(:label_not_contains) }
      end
    end

    it 'has _type QueryOperator' do
      is_expected
        .to be_json_eql('QueryOperator'.to_json)
        .at_path('_type')
    end

    it 'has id attribute' do
      is_expected
        .to be_json_eql(operator.to_sym.to_json)
        .at_path('id')
    end

    it 'has name attribute' do
      is_expected
        .to be_json_eql(I18n.t(:label_not_contains).to_json)
        .at_path('name')
    end
  end
end
