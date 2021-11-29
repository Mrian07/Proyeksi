

require 'spec_helper'

describe OpenProject::Bim::WorkPackage::Exporter::Formatters::BcfThumbnail do
  describe '::apply?' do
    it 'returns TRUE the bcf thumbnail' do
      expect(described_class).to be_apply(:bcf_thumbnail)
    end

    it 'returns FALSE for any other class' do
      expect(described_class).not_to be_apply(:whatever)
    end
  end

  describe '::format' do
    let(:work_package_with_viewpoint) { FactoryBot.create(:work_package) }
    let(:bcf_issue) { FactoryBot.create(:bcf_issue_with_viewpoint, work_package: work_package_with_viewpoint) }
    let(:work_package_without_viewpoint) { FactoryBot.create(:work_package) }

    before do
      bcf_issue
    end

    it 'returns "x" for work packages that have BCF issues with at least one viewpoint' do
      expect(described_class.new(:bcf_thumbnail).format(work_package_with_viewpoint)).to eql('x')
    end

    it 'returns "" for work packages without viewpoints attached' do
      expect(described_class.new(:bcf_thumbnail).format(work_package_without_viewpoint)).to eql('')
    end
  end
end
