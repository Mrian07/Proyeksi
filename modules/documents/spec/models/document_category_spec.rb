
require File.dirname(__FILE__) + '/../spec_helper'

describe DocumentCategory do
  let(:project) { FactoryBot.create(:project) }

  it "should be an enumeration" do
    expect(DocumentCategory.ancestors).to include Enumeration
  end

  it "should order documents by the category they are created with" do
    uncategorized = FactoryBot.create :document_category, name: "Uncategorized", project: project
    user_documentation = FactoryBot.create :document_category, name: "User documentation"

    FactoryBot.create_list :document, 2, category: uncategorized, project: project

    expect(DocumentCategory.find_by_name(uncategorized.name).objects_count).to eql 2
    expect(DocumentCategory.find_by_name(user_documentation.name).objects_count).to eql 0
  end

  it "should file the categorizations under the option name :enumeration_doc_categories" do
    expect(DocumentCategory.new.option_name).to eql :enumeration_doc_categories
  end

  it "should only allow one category to be the default-category" do
    old_default = FactoryBot.create :document_category, name: "old default", project: project, is_default: true

    expect do
      FactoryBot.create :document_category, name: "new default", project: project, is_default: true
      old_default.reload
    end.to change { old_default.is_default? }.from(true).to(false)
  end
end
