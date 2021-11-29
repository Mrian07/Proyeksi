

require 'spec_helper'
require 'rack/test'

describe 'API v3 String Objects resource' do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  describe 'string_objects' do
    subject(:response) { last_response }

    let(:path) { api_v3_paths.string_object 'foo bar' }

    before do
      get path
    end

    it 'return 410 GONE' do
      expect(subject.status).to eql(410)
    end

    context 'nil string' do
      let(:path) { '/api/v3/string_objects?value' }

      it 'return 410 GONE' do
        expect(subject.status).to eql(410)
      end
    end
  end
end
