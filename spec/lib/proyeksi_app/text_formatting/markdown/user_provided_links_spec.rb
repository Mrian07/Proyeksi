

require 'spec_helper'
require_relative './expected_markdown'

describe ProyeksiApp::TextFormatting,
         'user provided links' do
  include_context 'expected markdown modules'

  context 'hardened against tabnabbing' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          this is a <a style="display:none;" href="http://malicious">
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <p class="op-uc-p">
            this is a <a href="http://malicious" rel="noopener noreferrer" class="op-uc-link">
          </p>
        EXPECTED
      end
    end
  end

  context 'autolinks' do
    context 'for urls' do
      it_behaves_like 'format_text produces' do
        let(:raw) do
          <<~RAW
            Autolink to http://www.google.com
          RAW
        end

        let(:expected) do
          <<~EXPECTED
            <p class="op-uc-p">
              Autolink to <a href="http://www.google.com" class="op-uc-link">http://www.google.com</a>
            </p>
          EXPECTED
        end
      end
    end

    context 'for email addresses' do
      it_behaves_like 'format_text produces' do
        let(:raw) do
          <<~RAW
            Mailto link to foo@bar.com
          RAW
        end

        let(:expected) do
          <<~EXPECTED
            <p class="op-uc-p">
              Mailto link to <a href="mailto:foo@bar.com" class="op-uc-link">foo@bar.com</a>
            </p>
          EXPECTED
        end
      end
    end
  end

  context 'relative URLS' do
    context 'path_only is true (default)' do
      it_behaves_like 'format_text produces' do
        let(:raw) do
          <<~RAW
            Link to [relative path](/foo/bar)
          RAW
        end

        let(:expected) do
          <<~EXPECTED
            <p class="op-uc-p">
              Link to <a href="/foo/bar" class="op-uc-link" rel="noopener noreferrer">relative path</a>
            </p>
          EXPECTED
        end
      end
    end

    context 'path_only is false', with_settings: { host_name: "proyeksiapp.org" } do
      let(:options) { { only_path: false } }

      it_behaves_like 'format_text produces' do
        let(:raw) do
          <<~RAW
            Link to [relative path](/foo/bar)
          RAW
        end

        let(:expected) do
          <<~EXPECTED
            <p class="op-uc-p">
              Link to <a href="http://proyeksiapp.org/foo/bar" class="op-uc-link" rel="noopener noreferrer">relative path</a>
            </p>
          EXPECTED
        end
      end
    end
  end
end
