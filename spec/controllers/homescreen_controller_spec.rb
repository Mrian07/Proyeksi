

require 'spec_helper'

describe HomescreenController, type: :controller do
  before do
    login_as(user)

    # assume anonymous may access the page
    allow(Setting).to receive(:login_required?).and_return(false)
    allow(Setting).to receive(:welcome_on_homescreen?).and_return(show_welcome)
    get :index
  end

  let(:all_blocks) do
    %w(administration community my_account projects users)
  end

  let(:show_welcome) { false }

  shared_examples 'renders blocks' do
    it 'renders a response' do
      expect(response.status).to eq(200)
    end

    describe 'with rendered views' do
      render_views

      it 'renders the given blocks' do
        shown.each do |block|
          expect(response).to render_template(partial: "homescreen/blocks/_#{block}")
        end
      end

      it 'does not render the other blocks' do
        (all_blocks - shown).each do |block|
          expect(response).not_to render_template(partial: "homescreen/blocks/_#{block}")
        end
      end

      it 'does not render news when empty' do
        expect(response).not_to render_template(partial: 'homescreen/blocks/_news')
      end

      it 'shows the news when available' do
        expect(News).to receive(:latest).with(any_args)
          .and_return(FactoryBot.build_stubbed_list(:news, 5, created_at: Time.now))

        get :index
        expect(response).to render_template(partial: 'homescreen/blocks/_news')
      end

      it 'does not render the welcome block' do
        expect(response).not_to render_template(partial: 'homescreen/blocks/_welcome')
      end

      context 'with enabled announcement' do
        let!(:announcement) { FactoryBot.create :active_announcement }
        it 'renders the announcement' do
          expect(response).to render_template(partial: 'announcements/_show')
        end
      end

      context 'with enabled welcome block' do
        before do
          allow(Setting).to receive(:welcome_text).and_return('h1. foobar')
          allow(Setting).to receive(:welcome_title).and_return('Woohoo!')
          get :index
        end

        let(:show_welcome) { true }

        it 'renders the block' do
          expect(response).to render_template(partial: 'homescreen/blocks/_welcome')
        end

        it 'renders the text' do
          expect(response.body).to have_selector('[data-qa-selector="op-widget-box--header"]',
                                                 text: 'Woohoo!')
        end
      end
    end
  end

  context 'with admin' do
    let(:user) { FactoryBot.build(:admin) }
    it_behaves_like 'renders blocks' do
      let(:shown) { all_blocks }
    end
  end

  context 'regular user' do
    let(:user) { FactoryBot.build(:user) }
    it_behaves_like 'renders blocks' do
      let(:shown) { all_blocks - %w(administration users) }
    end
  end

  context 'anonymous user' do
    let(:user) { User.anonymous }
    it_behaves_like 'renders blocks' do
      let(:shown) { all_blocks - %w(administration users my_account) }
    end
  end
end
