

require 'spec_helper'

describe ::OpenProject::Bim::BcfXml::Exporter do
  let(:query) { FactoryBot.build(:global_query) }
  let(:work_package) { FactoryBot.create :work_package }
  let(:admin) { FactoryBot.create(:admin) }
  let(:current_user) { admin }

  before do
    work_package
    login_as current_user
  end

  subject { described_class.new(query) }

  context "one WP without BCF issue associated" do
    it '#work_packages' do
      expect(subject.work_packages.count).to eql(0)
    end
  end

  context "one WP with BCF issue associated" do
    let(:bcf_issue) { FactoryBot.create(:bcf_issue_with_comment, work_package: work_package) }

    before do
      bcf_issue
    end

    it '#work_packages' do
      expect(subject.work_packages.count).to eql(1)
    end
  end
end
