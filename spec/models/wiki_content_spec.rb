

require 'spec_helper'

describe WikiContent, type: :model do
  let(:content) { FactoryBot.create(:wiki_content, page: page, author: author) }

  shared_let(:wiki) { FactoryBot.create(:wiki) }
  shared_let(:page) { FactoryBot.create(:wiki_page, wiki: wiki) }
  shared_let(:author) do
    FactoryBot.create(:user,
                      member_in_project: wiki.project,
                      member_with_permissions: [:view_wiki_pages])
  end
  shared_let(:project_watcher) do
    FactoryBot.create(:user,
                      member_in_project: wiki.project,
                      member_with_permissions: [:view_wiki_pages])
  end

  shared_let(:wiki_watcher) do
    watcher = FactoryBot.create(:user,
                                member_in_project: wiki.project,
                                member_with_permissions: [:view_wiki_pages])
    wiki.watcher_users << watcher

    watcher
  end

  describe 'mail sending' do
    context 'when creating' do
      let(:content) { FactoryBot.build(:wiki_content, page: page) }

      it 'sends mails to the wiki`s watchers and project all watchers' do
        expect do
          perform_enqueued_jobs do
            User.execute_as(author) do
              content.save!
            end
          end
        end
          .to change { ActionMailer::Base.deliveries.size }
                .by(2)
      end
    end

    context 'when updating',
            with_settings: { journal_aggregation_time_minutes: 0 } do
      let(:page_watcher) do
        watcher = FactoryBot.create(:user,
                                    member_in_project: wiki.project,
                                    member_with_permissions: [:view_wiki_pages])
        page.watcher_users << watcher

        watcher
      end

      before do
        page_watcher

        content.text = 'My new content'
      end

      it 'sends mails to the watchers, the wiki`s watchers and project all watchers' do
        expect do
          perform_enqueued_jobs do
            User.execute_as(author) do
              content.save!
            end
          end
        end
          .to change { ActionMailer::Base.deliveries.size }
                .by(3)
      end
    end
  end

  describe '#version',
           with_settings: { journal_aggregation_time_minutes: 0 } do
    context 'when updating' do
      it 'updates the version' do
        content.text = 'My new content'

        expect { content.save! }
          .to change(content, :version)
                .by(1)
      end
    end

    context 'when creating' do
      it 'sets the version to 1' do
        content.save!

        expect(content.version)
          .to be 1
      end
    end

    context 'when new' do
      it 'starts with 0' do
        content = described_class.new(text: 'a', author: author, page: page)

        expect(content.version)
          .to be 0
      end
    end
  end

  describe '#author' do
    it 'sets the author' do
      expect(content.author)
        .to eql author
    end
  end

  describe '#journals',
           with_settings: { journal_aggregation_time_minutes: 0 } do
    context 'when creating' do
      it 'adds a journal' do
        expect(content.journals.count)
          .to be 1
      end

      it 'journalizes the text' do
        expect(content.journals.last.data.text)
          .to eql content.text
      end
    end

    context 'when updating' do
      let(:text) { 'My new content' }

      before do
        content.text = text
      end

      it 'adds a journal' do
        expect { content.save! }
          .to change(content.journals, :count)
                .by(1)
      end

      it 'journalizes the text' do
        content.save!

        expect(content.journals.last.data.text)
          .to eql content.text
      end
    end
  end

  describe '#text' do
    it 'doe not truncate to 64k' do
      content = described_class.create(text: 'a' * 500.kilobyte, author: author, page: page)
      content.reload
      expect(content.text.size)
        .to eql(500.kilobyte)
    end
  end
end
