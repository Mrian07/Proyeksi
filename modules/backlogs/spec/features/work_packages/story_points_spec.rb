

require 'spec_helper'

describe 'Work packages having story points', type: :feature, js: true do
  before do
    allow(User).to receive(:current).and_return current_user
    allow(Setting).to receive(:plugin_openproject_backlogs).and_return('points_burn_direction' => 'down',
                                                                       'wiki_template' => '',
                                                                       'card_spec' => 'Sattleford VM-5040',
                                                                       'story_types' => [story_type.id.to_s],
                                                                       'task_type' => task_type.id.to_s)
  end

  let(:current_user) { FactoryBot.create(:admin) }
  let(:project) do
    FactoryBot.create(:project,
                      enabled_module_names: %w(work_package_tracking backlogs))
  end
  let(:status) { FactoryBot.create :default_status }
  let(:story_type) { FactoryBot.create(:type_feature) }
  let(:task_type) { FactoryBot.create(:type_feature) }

  describe 'showing the story points on the work package show page' do
    let(:story_points) { 42 }
    let(:story_with_sp) do
      FactoryBot.create(:story,
                        type: story_type,
                        author: current_user,
                        project: project,
                        status: status,
                        story_points: story_points)
    end

    it 'should be displayed' do
      wp_page = Pages::FullWorkPackage.new(story_with_sp)

      wp_page.visit!
      wp_page.expect_subject

      wp_page.expect_attributes storyPoints: story_points

      wp_page.ensure_page_loaded
    end
  end
end
