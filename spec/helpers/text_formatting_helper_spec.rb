#-- encoding: UTF-8



require 'spec_helper'

describe TextFormattingHelper, type: :helper do
  describe '#preview_context' do
    context 'for a News' do
      let(:news) { FactoryBot.build_stubbed(:news) }

      it 'returns the v3 path' do
        expect(helper.preview_context(news))
          .to eql "/api/v3/news/#{news.id}"
      end
    end

    context 'for a Message' do
      let(:message) { FactoryBot.build_stubbed(:message) }

      it 'returns the v3 path' do
        expect(helper.preview_context(message))
          .to eql "/api/v3/posts/#{message.id}"
      end
    end

    context 'for a WikiPage' do
      let(:wiki_page) { FactoryBot.build_stubbed(:wiki_page) }

      it 'returns the v3 path' do
        expect(helper.preview_context(wiki_page))
          .to eql "/api/v3/wiki_pages/#{wiki_page.id}"
      end
    end
  end
end
