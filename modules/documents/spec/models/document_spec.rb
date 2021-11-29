
require File.dirname(__FILE__) + '/../spec_helper'

describe Document do
  let(:documentation_category) { FactoryBot.create :document_category, name: 'User documentation' }
  let(:project)                { FactoryBot.create :project }
  let(:user)                   { FactoryBot.create(:user) }
  let(:admin)                  { FactoryBot.create(:admin) }

  let(:mail) do
    mock = Object.new
    allow(mock).to receive(:deliver_now)
    mock
  end

  context "validation" do
    it { is_expected.to validate_presence_of :project }
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :category }
  end

  describe "create with a valid document" do
    let(:valid_document) { Document.new(title: "Test", project: project, category: documentation_category) }

    it "should add a document" do
      expect  do
        valid_document.save
      end.to change { Document.count }.by 1
    end

    it "should set a default-category, if none is given" do
      default_category = FactoryBot.create :document_category, name: 'Technical documentation', is_default: true
      document = Document.new(project: project, title: "New Document")
      expect(document.category).to eql default_category
      expect do
        document.save
      end.to change { Document.count }.by 1
    end

    it "with attachments should change the updated_at-date on the document to the attachment's date" do
      valid_document.save

      expect do
        Attachments::CreateService
          .new(user: admin)
          .call(container: valid_document, file: FactoryBot.attributes_for(:attachment)[:file], filename: 'foo')

        expect(valid_document.attachments.size).to eql 1
      end.to(change do
        valid_document.reload
        valid_document.updated_at
      end)
    end

    it "without attachments, the updated-on-date is taken from the document's date" do
      document = FactoryBot.create(:document, project: project)
      expect(document.attachments).to be_empty
      expect(document.created_at).to eql document.updated_at
    end
  end

  describe "acts as event" do
    let(:now) { Time.zone.now }
    let(:document) do
      FactoryBot.build(:document,
                       created_at: now)
    end

    it { expect(document.event_datetime.to_i).to eq(now.to_i) }
  end
end
