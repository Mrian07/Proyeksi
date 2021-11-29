

require 'spec_helper'
require 'requests/api/v3/attachments/attachment_resource_shared_examples'

describe "document attachments" do
  it_behaves_like "an APIv3 attachment resource" do
    let(:attachment_type) { :document }

    let(:create_permission) { :manage_documents }
    let(:read_permission) { :view_documents }
    let(:update_permission) { :manage_documents }

    let(:document) do
      FactoryBot.create :document, project: project
    end
  end
end

