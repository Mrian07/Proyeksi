

require 'spec_helper'
require_relative './ifc_upload_shared_examples'

describe 'IFC upload', type: :feature, js: true, with_config: { edition: 'bim' } do
  it_behaves_like 'can upload an IFC file' do
    let(:model_name) { 'minimal.ifc' }
  end
end
