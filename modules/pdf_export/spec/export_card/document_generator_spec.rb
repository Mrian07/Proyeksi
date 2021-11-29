

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe OpenProject::PDFExport::ExportCard::DocumentGenerator do
  let(:config) do
    ExportCardConfiguration.new({
                                  name: "Default",
                                  description: "This is a description",
                                  per_page: 1,
                                  page_size: "A4",
                                  orientation: "landscape",
                                  rows: "group1:\n  has_border: false\n  rows:\n    row1:\n      height: 50\n      priority: 1\n      columns:\n        subject:\n          has_label: false\n          font_size: 15\n    row2:\n      height: 50\n      priority: 1\n      columns:\n        non_existent:\n          has_label: true\n          font_size: 15\n          render_if_empty: true"
                                })
  end

  let(:work_package1) do
    WorkPackage.new({
                      subject: "Work package 1",
                      description: "This is a description"
                    })
  end

  let(:work_package2) do
    WorkPackage.new({
                      subject: "Work package 2",
                      description: "This is work package 2"
                    })
  end

  describe "Single work package rendering" do
    before(:each) do
      work_packages = [work_package1]
      @generator = OpenProject::PDFExport::ExportCard::DocumentGenerator.new(config, work_packages)
    end

    it 'shows work package subject' do
      text_analysis = PDF::Inspector::Text.analyze(@generator.render)
      expect(text_analysis.strings.include?('Work package 1')).to be_truthy
    end

    it 'does not show non existent field label' do
      text_analysis = PDF::Inspector::Text.analyze(@generator.render)
      expect(text_analysis.strings.include?('Non existent:')).to be_falsey
    end

    it 'should be 1 page' do
      page_analysis = PDF::Inspector::Page.analyze(@generator.render)
      expect(page_analysis.pages.size).to eq(1)
    end
  end

  describe "Multiple work package rendering" do
    before(:each) do
      work_packages = [work_package1, work_package2]
      @generator = OpenProject::PDFExport::ExportCard::DocumentGenerator.new(config, work_packages)
    end

    it 'shows work package subject' do
      text = PDF::Inspector::Text.analyze(@generator.render)
      expect(text.strings.include?('Work package 1')).to be_truthy
      expect(text.strings.include?('Work package 2')).to be_truthy
    end

    it 'should be 2 pages' do
      page_analysis = PDF::Inspector::Page.analyze(@generator.render)
      expect(page_analysis.pages.size).to eq(2)
    end
  end
end
