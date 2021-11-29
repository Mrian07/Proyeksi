

require 'spec_helper'
require_relative './attachment_resource_shared_examples'

describe "wiki page attachments" do
  it_behaves_like "an APIv3 attachment resource" do
    let(:attachment_type) { :wiki_page }

    let(:create_permission) { nil }
    let(:read_permission) { :view_wiki_pages }
    let(:update_permission) { %i(delete_wiki_pages_attachments edit_wiki_pages) }

    let(:wiki) { FactoryBot.create(:wiki, project: project) }
    let(:wiki_page) { FactoryBot.create(:wiki_page, wiki: wiki) }
  end
end
