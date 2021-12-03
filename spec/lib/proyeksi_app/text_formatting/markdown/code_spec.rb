

require 'spec_helper'
require_relative './expected_markdown'

describe ProyeksiApp::TextFormatting,
         'code' do
  include_context 'expected markdown modules'

  context 'inline code' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          this is `some code`
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <p class="op-uc-p">
            this is <code class="op-uc-code">some code</code>
          </p>
        EXPECTED
      end
    end

    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          this is `<Location /redmine>` some code
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <p class="op-uc-p">
            this is <code class="op-uc-code">&lt;Location /redmine&gt;</code> some code
          </p>
        EXPECTED
      end
    end
  end

  context 'block code' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          Text before

          ```
           some code
          ```

          Text after
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <p class="op-uc-p">
            Text before
          </p>

          <pre class="op-uc-code-block">
            some code
          </pre>

          <p class="op-uc-p">
            Text after
          </p>
        EXPECTED
      end
    end
  end

  context 'code block with language specified' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          Text before

          ```ruby
            def foobar
              some ruby code
            end
          ```

          Text after
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <p class="op-uc-p">
            Text before
          </p>

          <pre lang="ruby" class="highlight highlight-ruby op-uc-code-block">
            <span class="k">def</span> <span class="nf">foobar</span>
            <span class="n">some</span> <span class="n">ruby</span> <span class="n">code</span>
            <span class="k">end</span>
          </pre>

          <p class="op-uc-p">
            Text after
          </p>
        EXPECTED
      end
    end
  end

  context 'blubs' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        "\n\n    git clone git@github.com:opf/proyeksiapp.git\n\n"
      end

      let(:expected) do
        <<~EXPECTED
          <pre class="op-uc-code-block">
            git clone git@github.com:opf/proyeksiapp.git
          </pre>
        EXPECTED
      end
    end
  end
end
