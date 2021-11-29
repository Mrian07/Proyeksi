

require 'spec_helper'

describe 'repositories/stats', type: :view do
  let(:project) { FactoryBot.create(:project) }

  before do
    assign(:project, project)
  end

  describe 'requested by a user with view_commit_author_statistics permission' do
    before do
      assign(:show_commits_per_author, true)
      render
    end

    it 'should embed the commits per author graph' do
      expect(rendered).to include('commits_per_author')
    end
  end

  describe 'requested by a user without view_commit_author_statistics permission' do
    before do
      assign(:show_commits_per_author, false)
      render
    end

    it 'should NOT embed the commits per author graph' do
      expect(rendered).not_to include('commits_per_author')
    end
  end
end
