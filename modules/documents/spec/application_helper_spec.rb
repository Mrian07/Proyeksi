

require 'spec_helper'

describe ApplicationHelper do
  include ApplicationHelper
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  describe ".format_text" do
    let(:project) { FactoryBot.create :valid_project }
    let(:identifier) { project.identifier }
    let(:role) do
      FactoryBot.create(:role, permissions: %i[
                          view_work_packages edit_work_packages view_documents browse_repository view_changesets view_wiki_pages
                        ])
    end
    let(:project_member) do
      FactoryBot.create :user, member_in_project: project,
                               member_through_role: role
    end
    let(:document) do
      FactoryBot.create :document,
                        title: 'Test document',
                        project: project
    end

    before do
      @project = project
      allow(User).to receive(:current).and_return project_member
    end

    after do
      allow(User).to receive(:current).and_call_original
    end

    context "Simple Document links" do
      let(:document_link) do
        link_to('Test document',
                { controller: 'documents', action: 'show', id: document.id },
                class: 'document op-uc-link')
      end

      context "Plain link" do
        subject { format_text("document##{document.id}") }

        it { is_expected.to eq("<p class=\"op-uc-p\">#{document_link}</p>") }
      end

      context "Link with document name" do
        subject { format_text("document##{document.id}") }

        it { is_expected.to eq("<p class=\"op-uc-p\">#{document_link}</p>") }
      end

      context "Escaping plain link" do
        subject { format_text("!document##{document.id}") }

        it { is_expected.to eq("<p class=\"op-uc-p\">document##{document.id}</p>") }
      end

      context "Escaping link with document name" do
        subject { format_text('!document:"Test document"') }

        it { is_expected.to eq('<p class="op-uc-p">document:"Test document"</p>') }
      end
    end

    context 'Cross-Project Document Links' do
      let(:the_other_project) { FactoryBot.create :valid_project }

      context "By name without project" do
        subject { format_text("document:\"#{document.title}\"", project: the_other_project) }

        it { is_expected.to eq('<p class="op-uc-p">document:"Test document"</p>') }
      end

      context "By id and given project" do
        subject { format_text("#{identifier}:document##{document.id}", project: the_other_project) }

        it {
          is_expected.to eq("<p class=\"op-uc-p\"><a class=\"document op-uc-link\" href=\"/documents/#{document.id}\">Test document</a></p>")
        }
      end

      context "By name and given project" do
        subject { format_text("#{identifier}:document:\"#{document.title}\"", project: the_other_project) }

        it {
          is_expected.to eq("<p class=\"op-uc-p\"><a class=\"document op-uc-link\" href=\"/documents/#{document.id}\">Test document</a></p>")
        }
      end

      context "Invalid link" do
        subject { format_text("invalid:document:\"Test document\"", project: the_other_project) }

        it { is_expected.to eq('<p class="op-uc-p">invalid:document:"Test document"</p>') }
      end
    end
  end
end
