

require 'spec_helper'
require_relative './shared_contract_examples'

describe WikiPages::CreateContract do
  it_behaves_like 'wiki page contract' do
    subject(:contract) { described_class.new(page, current_user, options: {}) }

    let(:page) do
      WikiPage.new(wiki: page_wiki,
                   title: page_title,
                   slug: page_slug,
                   protected: page_protected,
                   parent: page_parent).tap do |page|
        page.build_content text: page_text,
                           author: page_author
        page.content.extend(ProyeksiApp::ChangedBySystem)
        page.content.changed_by_system(changed_by_system)

        allow(page)
          .to receive(:project)
          .and_return(page_wiki&.project)
      end
    end

    let(:changed_by_system) do
      if page_author
        { "author_id" => [nil, page_author.id] }
      else
        {}
      end
    end

    describe '#validation' do
      context 'if the author is different from the current user' do
        let(:page_author) { FactoryBot.build_stubbed(:user) }

        it 'is invalid' do
          expect_valid(false, author: :not_current_user)
        end
      end

      context 'if the author was not set by system' do
        let(:changed_by_system) { {} }

        it 'is invalid' do
          expect_valid(false, author_id: %i(error_readonly))
        end
      end
    end
  end
end
