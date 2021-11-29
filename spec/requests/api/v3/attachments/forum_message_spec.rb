

require 'spec_helper'
require_relative './attachment_resource_shared_examples'

describe "forum message attachments" do
  it_behaves_like "an APIv3 attachment resource", include_by_container = false do
    let(:attachment_type) { :forum_message }

    let(:create_permission) { nil }
    let(:read_permission) { nil }
    let(:update_permission) { :edit_messages }

    let(:forum) { FactoryBot.create(:forum, project: project) }
    let(:forum_message) { FactoryBot.create(:message, forum: forum) }

    let(:missing_permissions_user) { FactoryBot.create(:user) }
  end
end
