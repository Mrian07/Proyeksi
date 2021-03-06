#-- encoding: UTF-8


require 'spec_helper'
require File.expand_path('../support/shared/become_member', __dir__)

require 'support/shared/acts_as_watchable'

describe News, type: :model do
  include BecomeMember

  let(:project) do
    project = FactoryBot.create(:public_project)
    project.enabled_modules << EnabledModule.new(name: 'news')
    project.reload
  end

  let!(:news) { FactoryBot.create(:news, project: project) }
  let(:permissions) { [] }
  let(:role) { FactoryBot.build(:role, permissions: permissions) }

  it_behaves_like 'acts_as_watchable included' do
    let(:model_instance) { FactoryBot.create(:news) }
    let(:watch_permission) { :view_news }
    let(:project) { model_instance.project }
  end

  describe '.latest' do
    let(:project_news) { News.where(project: project) }

    before do
      Role.anonymous
    end

    it 'includes news elements from projects where news module is enabled' do
      expect(News.latest).to match_array [news]
    end

    it "doesn't include news elements from projects where news module is not enabled" do
      EnabledModule.where(project_id: project.id, name: 'news').delete_all

      expect(News.latest).to be_empty
    end

    it 'only includes news elements from projects that are visible to the user' do
      private_project = FactoryBot.create(:project, public: false)
      FactoryBot.create(:news, project: private_project)

      latest_news = News.latest(user: User.anonymous)
      expect(latest_news).to match_array [news]
    end

    it 'limits the number of returned news elements' do
      project_news.delete_all

      10.times do
        FactoryBot.create(:news, project: project)
      end

      expect(project_news.latest(user: User.current, count:  2).size).to eq(2)
      expect(project_news.latest(user: User.current, count:  6).size).to eq(6)
      expect(project_news.latest(user: User.current, count: 15).size).to eq(10)
    end

    it 'returns five news elements by default' do
      project_news.delete_all

      2.times do
        FactoryBot.create(:news, project: project)
      end

      expect(project_news.latest.size).to eq(2)

      3.times do
        FactoryBot.create(:news, project: project)
      end
      expect(project_news.latest.size).to eq(5)

      2.times do
        FactoryBot.create(:news, project: project)
      end
      expect(project_news.latest.size).to eq(5)
    end
  end

  describe '#save' do
    it 'sends email notifications when created' do
      FactoryBot.create(:user,
                        member_in_project: project,
                        member_through_role: role)
      project.members.reload

      perform_enqueued_jobs do
        FactoryBot.create(:news, project: project)
      end
      expect(ActionMailer::Base.deliveries.size).to eq(1)
    end
  end

  describe '#to_param' do
    it 'includes includes id and title for a nicer url' do
      title = 'ProyeksiApp now has a Twitter Account'
      news  = FactoryBot.create(:news, title: title)
      slug  = "#{news.id}-proyeksiapp-now-has-a-twitter-account"

      expect(news.to_param).to eq slug
    end

    it 'returns nil for unsaved news' do
      news = News.new
      expect(news.to_param).to be_nil
    end
  end
end
