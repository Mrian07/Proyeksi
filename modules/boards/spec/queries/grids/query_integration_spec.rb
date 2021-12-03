

require 'spec_helper'

describe Grids::Query, type: :model do
  include ProyeksiApp::StaticRouting::UrlHelpers

  shared_let(:project) { FactoryBot.create(:project) }
  shared_let(:other_project) { FactoryBot.create(:project) }
  shared_let(:show_board_views_role) { FactoryBot.create(:role, permissions: [:show_board_views]) }
  shared_let(:other_role) { FactoryBot.create(:role, permissions: []) }
  shared_let(:current_user) do
    FactoryBot.create(:user).tap do |user|
      FactoryBot.create(:member, user: user, project: project, roles: [show_board_views_role])
      FactoryBot.create(:member, user: user, project: other_project, roles: [other_role])
    end
  end
  let!(:board_grid) do
    FactoryBot.create(:board_grid, project: project)
  end
  let!(:other_board_grid) do
    FactoryBot.create(:board_grid, project: other_project)
  end
  let(:instance) { described_class.new }

  before do
    login_as(current_user)
  end

  context 'without a filter' do
    describe '#results' do
      it 'is the same as getting all the boards visible to the user' do
        expect(instance.results).to match_array [board_grid]
      end
    end
  end

  context 'with a scope filter' do
    context 'filtering for a projects/:project_id/boards' do
      before do
        instance.where('scope', '=', [project_work_package_boards_path(project)])
      end

      describe '#results' do
        it 'yields boards assigned to the project' do
          expect(instance.results).to match_array [board_grid]
        end
      end

      describe '#valid?' do
        it 'is true' do
          expect(instance).to be_valid
        end
      end
    end
  end
end
