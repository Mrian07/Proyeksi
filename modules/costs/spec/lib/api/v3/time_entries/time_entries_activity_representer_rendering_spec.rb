

require 'spec_helper'

describe ::API::V3::TimeEntries::TimeEntriesActivityRepresenter, 'rendering' do
  include ::API::V3::Utilities::PathHelper

  let(:activity) do
    FactoryBot.build_stubbed(:time_entry_activity)
  end
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:representer) do
    described_class.new(activity, current_user: user, embed_links: true)
  end

  subject { representer.to_json }

  describe '_links' do
    it_behaves_like 'has a titled link' do
      let(:link) { 'self' }
      let(:href) { api_v3_paths.time_entries_activity activity.id }
      let(:title) { activity.name }
    end

    # returns the projects where it (and it's children) is active
    it_behaves_like 'has a link collection' do
      let(:project1) { FactoryBot.build_stubbed(:project) }
      let(:project2) { FactoryBot.build_stubbed(:project) }

      before do
        allow(::Project)
          .to receive(:visible_with_activated_time_activity)
          .with(activity)
          .and_return([project1,
                       project2])
      end

      let(:link) { 'projects' }
      let(:hrefs) do
        [
          {
            href: api_v3_paths.project(project1.identifier),
            title: project1.name
          },
          {
            href: api_v3_paths.project(project2.identifier),
            title: project2.name
          }
        ]
      end
    end
  end

  describe 'properties' do
    it_behaves_like 'property', :_type do
      let(:value) { 'TimeEntriesActivity' }
    end

    it_behaves_like 'property', :id do
      let(:value) { activity.id }
    end

    it_behaves_like 'property', :name do
      let(:value) { activity.name }
    end

    it_behaves_like 'property', :position do
      let(:value) { activity.position }
    end

    it_behaves_like 'property', :default do
      let(:value) { activity.is_default }
    end
  end
end
