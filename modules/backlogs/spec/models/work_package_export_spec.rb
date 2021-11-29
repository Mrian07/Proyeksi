

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WorkPackage::PDFExport::WorkPackageToPdf, type: :model do
  let(:project) { FactoryBot.create :project }
  let(:query) { Query.new_default(name: '_', project: project) }
  subject { described_class.new query }

  before do
    query.column_names << :story_points
  end

  describe 'backlogs column' do
    it 'should contain the story_points column in valid export column names' do
      backlog_column = subject.columns.detect { |c| c.name == :story_points }
      expect(backlog_column).to be_present
    end
  end
end
