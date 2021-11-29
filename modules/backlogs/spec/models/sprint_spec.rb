

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Sprint, type: :model do
  let(:sprint) { FactoryBot.build(:sprint) }
  let(:project) { FactoryBot.build(:project) }

  describe 'Class Methods' do
    describe '#displayed_left' do
      describe 'WITH display set to left' do
        before(:each) do
          sprint.version_settings = [FactoryBot.build(:version_setting, project: project,
                                                                        display: VersionSetting::DISPLAY_LEFT)]
          sprint.project = project
          sprint.save!
        end

        it {
          expect(Sprint.displayed_left(project)).to match_array [sprint]
        }
      end

      describe 'WITH a version setting defined for another project' do
        before(:each) do
          another_project = FactoryBot.build(:project, name: 'another project',
                                                       identifier: 'another project')

          sprint.version_settings = [FactoryBot.build(:version_setting, project: another_project,
                                                                        display: VersionSetting::DISPLAY_RIGHT)]
          sprint.project = project
          sprint.save
        end

        it { expect(Sprint.displayed_left(project)).to match_array [sprint] }
      end

      describe 'WITH no version setting defined' do
        before(:each) do
          sprint.project = project
          sprint.save!
        end

        it { expect(Sprint.displayed_left(project)).to match_array [sprint] }
      end

      context 'WITH a shared version from another project' do
        let!(:parent_project) { FactoryBot.create :project, identifier: "parent", name: "Parent" }

        let!(:home_project) do
          FactoryBot.create(:project, identifier: "home", name: "Home").tap do |p|
            p.parent = parent_project
            p.save!
          end
        end

        let!(:sister_project) do
          FactoryBot.create(:project, identifier: "sister", name: "Sister").tap do |p|
            p.parent = parent_project
            p.save!
          end
        end

        let!(:version) { FactoryBot.create :version, name: "Shared Version", sharing: "tree", project: home_project }

        let(:displayed) { Sprint.apply_to(sister_project).displayed_left(sister_project) }

        describe 'WITH no version settings' do
          it "should include the shared version by default" do
            expect(displayed).to match_array [version]
          end
        end

        describe 'WITH display = left in home project' do
          before do
            VersionSetting.create version: version, project: home_project, display: VersionSetting::DISPLAY_LEFT
          end

          it "should include the shared version" do
            expect(displayed).to match_array [version]
          end
        end

        describe 'WITH display = none in home project' do
          before do
            VersionSetting.create version: version, project: home_project, display: VersionSetting::DISPLAY_NONE
          end

          it "should include the shared version" do
            expect(displayed).to match_array []
          end
        end

        describe 'WITH display = left in sister project' do
          before do
            VersionSetting.create version: version, project: sister_project, display: VersionSetting::DISPLAY_LEFT
          end

          it "should include the shared version" do
            expect(displayed).to match_array [version]
          end
        end

        describe 'WITH display = none in sister project' do
          before do
            VersionSetting.create version: version, project: sister_project, display: VersionSetting::DISPLAY_NONE
          end

          it "should not include the shared version" do
            expect(displayed).to match_array []
          end
        end

        describe 'WITH display = left in home project and display = left in sister project' do
          before do
            VersionSetting.create version: version, project: home_project, display: VersionSetting::DISPLAY_LEFT
            VersionSetting.create version: version, project: sister_project, display: VersionSetting::DISPLAY_LEFT
          end

          it "should include the shared version" do
            expect(displayed).to match_array [version]
          end
        end

        describe 'WITH display = left in home project and display = none in sister project' do
          before do
            VersionSetting.create version: version, project: home_project, display: VersionSetting::DISPLAY_LEFT
            VersionSetting.create version: version, project: sister_project, display: VersionSetting::DISPLAY_NONE
          end

          it "should not include the shared version" do
            expect(displayed).to match_array []
          end
        end

        describe 'WITH display = none in home project and display = left in sister project' do
          before do
            VersionSetting.create version: version, project: home_project, display: VersionSetting::DISPLAY_NONE
            VersionSetting.create version: version, project: sister_project, display: VersionSetting::DISPLAY_LEFT
          end

          it "should include the shared version" do
            expect(displayed).to match_array [version]
          end
        end

        describe 'WITH display = none in home project and display = none in sister project' do
          before do
            VersionSetting.create version: version, project: home_project, display: VersionSetting::DISPLAY_NONE
            VersionSetting.create version: version, project: sister_project, display: VersionSetting::DISPLAY_NONE
          end

          it "should not include the shared version" do
            expect(displayed).to match_array []
          end
        end
      end
    end

    describe '#displayed_right' do
      before(:each) do
        sprint.version_settings = [FactoryBot.build(:version_setting, project: project, display: VersionSetting::DISPLAY_RIGHT)]
        sprint.project = project
        sprint.save!
      end

      it { expect(Sprint.displayed_right(project)).to match_array [sprint] }
    end

    describe '#order_by_date' do
      before(:each) do
        @sprint1 = FactoryBot.create(:sprint, name: 'sprint1', project: project, start_date: Date.today + 2.days)
        @sprint2 = FactoryBot.create(:sprint, name: 'sprint2', project: project, start_date: Date.today + 1.day,
                                              effective_date: Date.today + 3.days)
        @sprint3 = FactoryBot.create(:sprint, name: 'sprint3', project: project, start_date: Date.today + 1.day,
                                              effective_date: Date.today + 2.days)
      end

      it 'sorts the dates correctly', :aggregate_failures do
        expect(Sprint.order_by_date[0]).to eql @sprint3
        expect(Sprint.order_by_date[1]).to eql @sprint2
        expect(Sprint.order_by_date[2]).to eql @sprint1
      end
    end

    describe '#apply_to' do
      before(:each) do
        project.save
        @other_project = FactoryBot.create(:project)
      end

      describe 'WITH the version being shared system wide' do
        before(:each) do
          @version = FactoryBot.create(:sprint, name: 'systemwide', project: @other_project, sharing: 'system')
        end

        it { expect(Sprint.apply_to(project).size).to eq(1) }
        it { expect(Sprint.apply_to(project)[0]).to eql(@version) }
      end

      describe 'WITH the version being shared from a parent project' do
        before(:each) do
          project.update(parent: @other_project)
          project.reload
          @version = FactoryBot.create(:sprint, name: 'descended', project: @other_project, sharing: 'descendants')
        end

        it { expect(Sprint.apply_to(project).size).to eq(1) }
        it { expect(Sprint.apply_to(project)[0]).to eql(@version) }
      end

      describe 'WITH the version being shared within the tree' do
        before(:each) do
          @parent_project = FactoryBot.create(:project)
          @other_project.update(parent: @parent_project)
          project.update(parent: @parent_project)
          project.reload
          @version = FactoryBot.create(:sprint, name: 'treed', project: @other_project, sharing: 'tree')
        end

        it { expect(Sprint.apply_to(project).size).to eq(1) }
        it { expect(Sprint.apply_to(project)[0]).to eql(@version) }
      end

      describe 'WITH the version being shared within the tree' do
        before(:each) do
          @descendant_project = FactoryBot.create(:project, parent: project)
          project.reload
          @version = FactoryBot.create(:sprint, name: 'hierar', project: @descendant_project, sharing: 'hierarchy')
        end

        it { expect(Sprint.apply_to(project).size).to eq(1) }
        it { expect(Sprint.apply_to(project)[0]).to eql(@version) }
      end
    end
  end
end
