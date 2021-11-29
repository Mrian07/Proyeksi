

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Backlog, type: :model do
  let(:project) { FactoryBot.build(:project) }

  before(:each) do
    @feature = FactoryBot.create(:type_feature)
    allow(Setting).to receive(:plugin_openproject_backlogs).and_return({ 'story_types' => [@feature.id.to_s],
                                                                         'task_type' => '0' })
    @status = FactoryBot.create(:status)
  end

  describe 'Class Methods' do
    describe '#owner_backlogs' do
      describe 'WITH one open version defined in the project' do
        before(:each) do
          @project = project
          @work_packages = [FactoryBot.create(:work_package, subject: 'work_package1', project: @project, type: @feature,
                                                             status: @status)]
          @version = FactoryBot.create(:version, project: project, work_packages: @work_packages)
          @version_settings = @version.version_settings.create(display: VersionSetting::DISPLAY_RIGHT, project: project)
        end

        it { expect(Backlog.owner_backlogs(@project)[0]).to be_owner_backlog }
      end
    end
  end
end
