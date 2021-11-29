

require 'spec_helper'
require_relative './expected_markdown'

describe OpenProject::TextFormatting,
         'headings' do
  include_context 'expected markdown modules'

  describe '.format_text' do
    shared_examples_for 'bem heading' do |level|
      it_behaves_like 'format_text produces' do
        let(:raw) do
          <<~RAW
            Some text before

            #{'#' * level} the heading

            more text
          RAW
        end

        let(:expected) do
          <<~EXPECTED
            <p class="op-uc-p">Some text before</p>
            <h#{level} class="op-uc-h#{level}" id="the-heading">
              the heading
              <a class="op-uc-link_permalink icon-link op-uc-link" aria-hidden="true" href="#the-heading"></a>
            </h#{level}>
            <p class="op-uc-p">more text</p>
          EXPECTED
        end
      end
    end

    it_behaves_like 'bem heading', 1
    it_behaves_like 'bem heading', 2
    it_behaves_like 'bem heading', 3
    it_behaves_like 'bem heading', 4
    it_behaves_like 'bem heading', 5
    it_behaves_like 'bem heading', 6

    context 'with the heading being in a code bock' do
      shared_examples_for 'unchanged heading' do |level|
        it_behaves_like 'format_text produces' do
          let(:raw) do
            <<~RAW
              Some text before

              ```
              <h#{level}>The heading </h#{level}>

              ```

              more text
            RAW
          end

          let(:expected) do
            <<~EXPECTED
              <p class="op-uc-p">Some text before</p>

              <pre class='op-uc-code-block'>
              &lt;h#{level}&gt;The heading &lt;/h#{level}&gt;

              </pre>

              <p class="op-uc-p">more text</p>
            EXPECTED
          end
        end
      end

      it_behaves_like 'unchanged heading', 1
      it_behaves_like 'unchanged heading', 2
      it_behaves_like 'unchanged heading', 3
      it_behaves_like 'unchanged heading', 4
      it_behaves_like 'unchanged heading', 5
      it_behaves_like 'unchanged heading', 6
    end

    context 'with the heading being a date (number and backslash)' do
      it_behaves_like 'format_text produces' do
        let(:raw) do
          '# 2009\02\09'
        end

        let(:expected) do
          <<~EXPECTED.strip_heredoc
            <h1 class="op-uc-h1" id="20090209">
              2009\\02\\09
              <a class="op-uc-link_permalink icon-link op-uc-link" href="#20090209" aria-hidden="true"></a>
            </h1>
          EXPECTED
        end
      end
    end
  end
end
