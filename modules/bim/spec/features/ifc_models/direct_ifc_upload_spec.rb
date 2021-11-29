

require 'spec_helper'
require_relative './ifc_upload_shared_examples'

describe 'direct IFC upload', type: :feature, js: true, with_direct_uploads: :redirect, with_config: { edition: 'bim' } do
  it_behaves_like 'can upload an IFC file' do
    # with direct upload, we don't get the model name
    let(:model_name) { 'model.ifc' }
  end
end
