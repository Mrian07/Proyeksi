

require 'spec_helper'
require File.join(Rails.root, 'spec', 'requests', 'api', 'v3', 'attachments', 'attachment_resource_shared_examples')

describe "grid attachments" do
  before do
    Grids::Dashboard
  end

  it_behaves_like "an APIv3 attachment resource" do
    let(:attachment_type) { :grid }

    let(:create_permission) { :manage_dashboards }
    let(:read_permission) { :view_dashboards }
    let(:update_permission) { :manage_dashboards }

    let(:grid) { FactoryBot.create(:dashboard, project: project) }

    let(:missing_permissions_user) { FactoryBot.create(:user) }
  end
end
