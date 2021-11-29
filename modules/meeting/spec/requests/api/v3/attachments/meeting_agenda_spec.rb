

require 'spec_helper'
require 'requests/api/v3/attachments/attachment_resource_shared_examples'

describe "meeting agenda attachments" do
  it_behaves_like "an APIv3 attachment resource" do
    let(:attachment_type) { :meeting_content }

    let(:create_permission) { :create_meetings }
    let(:read_permission) { :view_meetings }
    let(:update_permission) { :edit_meetings }

    let(:meeting_content) { FactoryBot.create :meeting_agenda, meeting: meeting }
    let(:meeting) { FactoryBot.create :meeting, project: project }
  end
end
