
require File.dirname(__FILE__) + '/../spec_helper'

describe DocumentsMailer do
  let(:user) do
    FactoryBot.create(:user, firstname: 'Test', lastname: "User", mail: 'test@test.com')
  end
  let(:project) { FactoryBot.create(:project, name: "TestProject") }
  let(:document) do
    FactoryBot.create(:document, project: project, description: "Test Description", title: "Test Title")
  end
  let(:mail) { DocumentsMailer.document_added(user, document) }

  describe "document added-mail" do
    it "renders the subject" do
      expect(mail.subject).to eql '[TestProject] New document: Test Title'
    end

    it "should render the receivers mail" do
      expect(mail.to.count).to eql 1
      expect(mail.to.first).to eql user.mail
    end

    it "should render the document-info into the body" do
      expect(mail.body.encoded).to match(document.description)
      expect(mail.body.encoded).to match(document.title)
    end
  end
end
