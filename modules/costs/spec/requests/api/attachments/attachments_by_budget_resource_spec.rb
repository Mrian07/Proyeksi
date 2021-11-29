

require 'spec_helper'
require 'requests/api/v3/attachments/attachment_resource_shared_examples'

describe "budget attachments" do
  it_behaves_like "an APIv3 attachment resource" do
    let(:attachment_type) { :budget }

    let(:create_permission) { :edit_budgets }
    let(:read_permission) { :view_budgets }
    let(:update_permission) { :edit_budgets }

    let(:budget) do
      FactoryBot.create :budget, project: project
    end
  end
end

