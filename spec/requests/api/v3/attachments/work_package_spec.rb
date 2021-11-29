

require 'spec_helper'
require_relative './attachment_resource_shared_examples'

describe "work package attachments" do
  it_behaves_like "an APIv3 attachment resource" do
    let(:attachment_type) { :work_package }

    let(:create_permission) { :add_work_packages }
    let(:read_permission) { :view_work_packages }
    let(:update_permission) { :edit_work_packages }

    let(:work_package) do
      FactoryBot.create :work_package, author: current_user, project: project
    end
  end
end
