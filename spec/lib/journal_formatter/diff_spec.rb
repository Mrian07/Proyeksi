

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper.rb')

describe OpenProject::JournalFormatter::Diff do
  include ActionView::Helpers::TagHelper
  # WARNING: the order of the modules is important to ensure that url_for of
  # ActionController::UrlWriter is called and not the one of ActionView::Helpers::UrlHelper
  include ActionView::Helpers::UrlHelper

  def url_helper
    Rails.application.routes.url_helpers
  end

  let(:klass) { OpenProject::JournalFormatter::Diff }
  let(:id) { 1 }
  let(:journal) do
    OpenStruct.new(id: id, journable: WorkPackage.new)
  end
  let(:instance) { klass.new(journal) }
  let(:key) { 'description' }

  let(:url) do
    url_helper.diff_journal_path(id: journal.id,
                                 field: key.downcase)
  end
  let(:full_url) do
    url_helper.diff_journal_url(id: journal.id,
                                field: key.downcase,
                                protocol: Setting.protocol,
                                host: Setting.host_name)
  end
  let(:link) { link_to(I18n.t(:label_details), url, class: 'description-details') }
  let(:full_url_link) { link_to(I18n.t(:label_details), full_url, class: 'description-details') }

  describe '#render' do
    describe 'WITH the first value being nil, and the second a string' do
      let(:expected) do
        I18n.t(:text_journal_set_with_diff,
               label: "<strong>#{key.camelize}</strong>",
               link: link)
      end

      it { expect(instance.render(key, [nil, 'new value'])).to eq(expected) }
    end

    describe 'WITH the first value being a string, and the second a string' do
      let(:expected) do
        I18n.t(:text_journal_changed_with_diff,
               label: "<strong>#{key.camelize}</strong>",
               link: link)
      end

      it { expect(instance.render(key, ['old value', 'new value'])).to eq(expected) }
    end

    describe "WITH the first value being a string, and the second a string
              WITH de as locale" do
      let(:expected) do
        I18n.t(:text_journal_changed_with_diff,
               label: '<strong>Beschreibung</strong>',
               link: link)
      end

      before do
        I18n.locale = :de
      end

      it { expect(instance.render(key, ['old value', 'new value'])).to eq(expected) }

      after do
        I18n.locale = :en
      end
    end

    describe 'WITH the first value being a string, and the second nil' do
      let(:expected) do
        I18n.t(:text_journal_deleted_with_diff,
               label: "<strong>#{key.camelize}</strong>",
               link: link)
      end

      it { expect(instance.render(key, ['old_value', nil])).to eq(expected) }
    end

    describe "WITH the first value being nil, and the second a string
              WITH specifying not to output html" do
      let(:expected) do
        I18n.t(:text_journal_set_with_diff,
               label: key.camelize,
               link: url)
      end

      it { expect(instance.render(key, [nil, 'new value'], no_html: true)).to eq(expected) }
    end

    describe "WITH the first value being a string, and the second a string
              WITH specifying not to output html" do
      let(:expected) do
        I18n.t(:text_journal_changed_with_diff,
               label: key.camelize,
               link: url)
      end

      it { expect(instance.render(key, ['old value', 'new value'], no_html: true)).to eq(expected) }
    end

    describe "WITH the first value being a string, and the second a string
              WITH specifying to output a full url" do
      let(:expected) do
        I18n.t(:text_journal_changed_with_diff,
               label: "<strong>#{key.camelize}</strong>",
               link: full_url_link)
      end

      it { expect(instance.render(key, ['old value', 'new value'], only_path: false)).to eq(expected) }
    end

    describe 'WITH the first value being a string, and the second nil' do
      let(:expected) do
        I18n.t(:text_journal_deleted_with_diff,
               label: key.camelize,
               link: url)
      end

      it { expect(instance.render(key, ['old_value', nil], no_html: true)).to eq(expected) }
    end
  end
end
