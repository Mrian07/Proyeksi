

require 'spec_helper'

describe Rack::Deflater, type: :request do
  include API::V3::Utilities::PathHelper

  let(:text) { 'text' }

  it 'produces an identical eTag whether content is deflated or not' do
    # Using the api_v3_paths.configuration because of the endpoint's simplicity.
    # It could be any endpoint really.
    get api_v3_paths.configuration

    expect(last_response.headers['Content-Encoding']).to be_nil

    etag = last_response.headers['Etag']
    content_length = last_response.headers['Content-Length'].to_i

    header "Accept-Encoding", "gzip"
    get api_v3_paths.configuration

    expect(last_response.headers['Etag']).to eql etag
    expect(last_response.headers['Content-Length'].to_i).to_not eql content_length
    expect(last_response.headers['Content-Encoding']).to eql 'gzip'
  end
end
