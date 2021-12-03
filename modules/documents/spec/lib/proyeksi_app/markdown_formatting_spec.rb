

require 'spec_helper'

describe ProyeksiApp::TextFormatting,
         'Document links' do
  include ActionView::Helpers::UrlHelper # soft-dependency
  include ActionView::Context
  include ProyeksiApp::StaticRouting::UrlHelpers

  def controller
    # no-op
  end

  shared_let(:project) do
    FactoryBot.create :project, enabled_module_names: %w[documents]
  end

  shared_let(:document) do
    FactoryBot.create :document, project: project, title: 'My document'
  end

  subject do
    ::ProyeksiApp::TextFormatting::Renderer.format_text(text, only_path: true)
  end

  before do
    login_as user
  end

  let(:text) do
    <<~TEXT
      document##{document.id}

      document:"My document"
    TEXT
  end

  context 'when visible' do
    let(:role) { FactoryBot.create :role, permissions: %i[view_documents view_project] }
    let(:user) { FactoryBot.create :user, member_in_project: project, member_through_role: role }

    let(:expected) do
      <<~HTML
        <p class="op-uc-p">#{document_link}</p>

        <p class="op-uc-p">#{document_link}</p>
      HTML
    end

    let(:document_link) do
      link_to(
        'My document',
        { controller: '/documents', action: 'show', id: document.id, only_path: true },
        class: 'document op-uc-link'
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
        <p class="op-uc-p">document##{document.id}</p>

        <p class="op-uc-p">document:"My document"</p>
      HTML
    end

    it 'renders the raw text' do
      expect(subject).to be_html_eql(expected)
    end
  end
end
