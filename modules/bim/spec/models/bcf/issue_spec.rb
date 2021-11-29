

require 'spec_helper'

describe ::Bim::Bcf::Issue, type: :model do
  let(:type) { FactoryBot.create :type, name: "Issue [BCF]" }
  let(:work_package) { FactoryBot.create :work_package, type: type }
  let(:issue) { FactoryBot.create :bcf_issue, work_package: work_package }

  context '#markup_doc' do
    subject { issue }

    it "returns a Nokogiri::XML::Document" do
      expect(subject.markup_doc).to be_a Nokogiri::XML::Document
    end

    it "caches the document" do
      first_fetched_doc = subject.markup_doc
      expect(subject.markup_doc).to be_eql(first_fetched_doc)
    end

    it "invalidates the cache after an update of the issue" do
      first_fetched_doc = subject.markup_doc
      subject.markup = subject.markup + ' '
      subject.save
      expect(subject.markup_doc).to_not be_eql(first_fetched_doc)
    end
  end

  describe '.of_project' do
    let!(:other_work_package) { FactoryBot.create :work_package, type: type }
    let!(:other_issue) { FactoryBot.create :bcf_issue, work_package: other_work_package }

    it 'returns all issues of the provided project' do
      expect(described_class.of_project(issue.project))
        .to match_array [issue]
    end
  end
end
