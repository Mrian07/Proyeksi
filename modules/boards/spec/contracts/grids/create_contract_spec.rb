#-- encoding: UTF-8



require 'spec_helper'

describe Grids::CreateContract, 'for Boards::Grid' do
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:grid) do
    FactoryBot.create(:board_grid, project: project)
  end
  include_context 'model contract'

  let(:instance) { described_class.new(grid, user) }

  describe 'user_id' do
    it_behaves_like 'is not writable' do
      let(:attribute) { :user_id }
      let(:value) { 5 }
    end
  end

  describe 'project_id' do
    it_behaves_like 'is writable' do
      let(:attribute) { :project_id }
      let(:value) { 5 }
    end
  end
end
