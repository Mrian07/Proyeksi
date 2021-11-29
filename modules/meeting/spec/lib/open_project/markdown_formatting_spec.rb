

require 'spec_helper'

describe OpenProject::TextFormatting,
         'Meeting links' do
  include ActionView::Helpers::UrlHelper # soft-dependency
  include ActionView::Context
  include OpenProject::StaticRouting::UrlHelpers

  def controller
    # no-op
  end

  shared_let(:project) do
    FactoryBot.create :project, enabled_module_names: %w[meetings]
  end

  shared_let(:meeting) do
    FactoryBot.create :meeting, project: project, title: 'Monthly coordination'
  end

  subject do
    ::OpenProject::TextFormatting::Renderer.format_text(text, only_path: true)
  end

  before do
    login_as user
  end

  let(:text) do
    <<~TEXT
      meeting##{meeting.id}

      meeting:"monthly coordination"

      meeting:"Monthly coordination"
    TEXT
  end

  context 'when visible' do
    let(:role) { FactoryBot.create :role, permissions: %i[view_meetings view_project] }
    let(:user) { FactoryBot.create :user, member_in_project: project, member_through_role: role }

    let(:expected) do
      <<~HTML
        <p class="op-uc-p">#{meeting_link}</p>

        <p class="op-uc-p">#{meeting_link}</p>

        <p class="op-uc-p">#{meeting_link}</p>
      HTML
    end

    let(:meeting_link) do
      link_to(
        'Monthly coordination',
        { controller: '/meetings', action: 'show', id: meeting.id, only_path: true },
        class: 'meeting op-uc-link'
      )
    end

    it 'renders the links' do
      expect(subject).to be_html_eql(expected)
    end
  end

  context 'when not visible' do
    let(:user) { FactoryBot.create :user }

    let(:expected) do
      <<~HTML
        <p class="op-uc-p">meeting##{meeting.id}</p>

        <p class="op-uc-p">meeting:"monthly coordination"</p>

        <p class="op-uc-p">meeting:"Monthly coordination"</p>
      HTML
    end

    it 'renders the raw text' do
      expect(subject).to be_html_eql(expected)
    end
  end
end
