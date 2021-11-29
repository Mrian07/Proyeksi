

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper.rb')

describe OpenProject::JournalFormatter::Attachment do
  include ApplicationHelper
  include ActionView::Helpers::TagHelper
  # WARNING: the order of the modules is important to ensure that url_for of
  # ActionController::UrlWriter is called and not the one of ActionView::Helpers::UrlHelper
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers

  def self.default_url_options
    { only_path: true }
  end

  let(:klass) { OpenProject::JournalFormatter::Attachment }
  let(:instance) { klass.new(journal) }
  let(:id) { 1 }
  let(:journal) do
    OpenStruct.new(id: id)
  end
  let(:user) { FactoryBot.create(:user) }
  let(:attachment) do
    FactoryBot.create(:attachment,
                      author: user)
  end
  let(:key) { "attachments_#{attachment.id}" }

  describe '#render' do
    describe 'WITH the first value being nil, and the second an id as string' do
      it 'adds an attachment added text' do
        link = "#{Setting.protocol}://#{Setting.host_name}/api/v3/attachments/#{attachment.id}/content"
        expect(instance.render(key, [nil, attachment.id.to_s]))
          .to eq(I18n.t(:text_journal_added,
                        label: "<strong>#{I18n.t(:'activerecord.models.attachment')}</strong>",
                        value: "<a href=\"#{link}\">#{attachment.filename}</a>"))
      end

      context 'WITH a relative_url_root' do
        before do
          allow(OpenProject::Configuration)
            .to receive(:rails_relative_url_root)
                  .and_return('/blubs')
        end

        it 'adds an attachment added text' do
          link = "#{Setting.protocol}://#{Setting.host_name}/blubs/api/v3/attachments/#{attachment.id}/content"
          expect(instance.render(key, [nil, attachment.id.to_s]))
            .to eq(I18n.t(:text_journal_added,
                          label: "<strong>#{I18n.t(:'activerecord.models.attachment')}</strong>",
                          value: "<a href=\"#{link}\">#{attachment.filename}</a>"))
        end
      end
    end

    describe 'WITH the first value being an id as string, and the second nil' do
      let(:expected) do
        I18n.t(:text_journal_deleted,
               label: "<strong>#{I18n.t(:'activerecord.models.attachment')}</strong>",
               old: "<strike><i title=\"#{attachment.id}\">#{attachment.id}</i></strike>")
      end

      it { expect(instance.render(key, [attachment.id.to_s, nil])).to eq(expected) }
    end

    describe "WITH the first value being nil, and the second an id as a string
              WITH specifying not to output html" do
      let(:expected) do
        I18n.t(:text_journal_added,
               label: I18n.t(:'activerecord.models.attachment'),
               value: attachment.id)
      end

      it { expect(instance.render(key, [nil, attachment.id.to_s], no_html: true)).to eq(expected) }
    end

    describe "WITH the first value being an id as string, and the second nil,
              WITH specifying not to output html" do
      let(:expected) do
        I18n.t(:text_journal_deleted,
               label: I18n.t(:'activerecord.models.attachment'),
               old: attachment.id)
      end

      it { expect(instance.render(key, [attachment.id.to_s, nil], no_html: true)).to eq(expected) }
    end
  end
end
