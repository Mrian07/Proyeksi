

require 'spec_helper'
require_relative './expected_markdown'

describe OpenProject::TextFormatting,
         'toc macro' do
  include_context 'expected markdown modules'

  it_behaves_like 'format_text produces' do
    let(:raw) do
      <<~RAW
        <macro class="toc op-uc-placeholder"></macro>

        # The first h1 heading

        Some text after the first h1 heading

        ## The first h2 heading

        Some text after the first h2 heading

        ### The first h3 heading

        Some text after the first h3 heading

        # The second h1 heading

        Some text after the second h1 heading

        ## The second h2 heading

        Some text after the second h2 heading

        ### The second h3 heading

        Some text after the second h3 heading
      RAW
    end

    let(:expected) do
      <<~EXPECTED
        <p class="op-uc-p">
          <nav class="op-uc-toc">
            <ul class="op-uc-toc--list">
              <li class="op-uc-toc--list-item">
                <a class="op-uc-toc--item-link op-uc-link" href="#the-first-h1-heading">
                  <span class="op-uc-toc--list-item-number">1</span>
                  <span class="op-uc-toc--list-item-title">The first h1 heading</span>
                </a>
              </li>
              <ul class="op-uc-toc--list">
                <li class="op-uc-toc--list-item">
                  <a class="op-uc-toc--item-link op-uc-link" href="#the-first-h2-heading">
                    <span class="op-uc-toc--list-item-number">1.1</span>
                    <span class="op-uc-toc--list-item-title">The first h2 heading</span>
                  </a>
                </li>
                <ul class="op-uc-toc--list">
                  <li class="op-uc-toc--list-item">
                    <a class="op-uc-toc--item-link op-uc-link" href="#the-first-h3-heading">
                      <span class="op-uc-toc--list-item-number">1.1.1</span>
                      <span class="op-uc-toc--list-item-title">The first h3 heading</span>
                    </a>
                  </li>
                </ul>
              </ul>
              <li class="op-uc-toc--list-item">
                <a class="op-uc-toc--item-link op-uc-link" href="#the-second-h1-heading">
                  <span class="op-uc-toc--list-item-number">2</span>
                  <span class="op-uc-toc--list-item-title">The second h1 heading</span>
                </a>
              </li>
              <ul class="op-uc-toc--list">
                <li class="op-uc-toc--list-item">
                  <a class="op-uc-toc--item-link op-uc-link" href="#the-second-h2-heading">
                    <span class="op-uc-toc--list-item-number">2.1</span>
                    <span class="op-uc-toc--list-item-title">The second h2 heading</span>
                  </a>
                </li>
                <ul class="op-uc-toc--list">
                  <li class="op-uc-toc--list-item">
                    <a class="op-uc-toc--item-link op-uc-link" href="#the-second-h3-heading">
                      <span class="op-uc-toc--list-item-number">2.1.1</span>
                      <span class="op-uc-toc--list-item-title">The second h3 heading</span>
                    </a>
                  </li>
                </ul>
              </ul>
            </ul>
          </nav>
        </p>
        <h1 class="op-uc-h1" id="the-first-h1-heading">
          The first h1 heading
          <a class="op-uc-link_permalink icon-link op-uc-link" href="#the-first-h1-heading" aria-hidden="true"></a>
        </h1>
        <p class="op-uc-p">Some text after the first h1 heading</p>
        <h2 class="op-uc-h2" id="the-first-h2-heading">
          The first h2 heading
          <a class="op-uc-link_permalink icon-link op-uc-link" href="#the-first-h2-heading" aria-hidden="true"></a>
        </h2>
        <p class="op-uc-p">Some text after the first h2 heading</p>
        <h3 class="op-uc-h3" id="the-first-h3-heading">
          The first h3 heading
          <a class="op-uc-link_permalink icon-link op-uc-link" href="#the-first-h3-heading" aria-hidden="true"></a>
        </h3>
        <p class="op-uc-p">Some text after the first h3 heading</p>
        <h1 class="op-uc-h1" id="the-second-h1-heading">
          The second h1 heading
          <a class="op-uc-link_permalink icon-link op-uc-link" href="#the-second-h1-heading" aria-hidden="true"></a>
        </h1>
        <p class="op-uc-p">Some text after the second h1 heading</p>
        <h2 class="op-uc-h2" id="the-second-h2-heading">
          The second h2 heading
          <a class="op-uc-link_permalink icon-link op-uc-link" href="#the-second-h2-heading" aria-hidden="true"></a>
        </h2>
        <p class="op-uc-p">Some text after the second h2 heading</p>
        <h3 class="op-uc-h3" id="the-second-h3-heading">
          The second h3 heading
          <a class="op-uc-link_permalink icon-link op-uc-link" href="#the-second-h3-heading" aria-hidden="true"></a>
        </h3>
        <p class="op-uc-p">Some text after the second h3 heading</p>
      EXPECTED
    end
  end

  context 'headings with numbers' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          <macro class="toc op-uc-placeholder"></macro>

          # 1 The first h1 heading

          Some text after the first h1 heading

          ## 1.1 The first h2 heading

          Some text after the first h2 heading

          ### 1.1.1. The first h3 heading

          Some text after the first h3 heading

          # 2) The second h1 heading

          Some text after the second h1 heading

          ## 2.1) The second h2 heading

          Some text after the second h2 heading

          ### 2.1.1 - The second h3 heading

          Some text after the second h3 heading
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <p class="op-uc-p">
            <nav class="op-uc-toc">
              <ul class="op-uc-toc--list">
                <li class="op-uc-toc--list-item">
                  <a class="op-uc-toc--item-link op-uc-link" href="#1-the-first-h1-heading">
                    <span class="op-uc-toc--list-item-number">1</span>
                    <span class="op-uc-toc--list-item-title">The first h1 heading</span>
                  </a>
                </li>
                <ul class="op-uc-toc--list">
                  <li class="op-uc-toc--list-item">
                    <a class="op-uc-toc--item-link op-uc-link" href="#11-the-first-h2-heading">
                      <span class="op-uc-toc--list-item-number">1.1</span>
                      <span class="op-uc-toc--list-item-title">The first h2 heading</span>
                    </a>
                  </li>
                  <ul class="op-uc-toc--list">
                    <li class="op-uc-toc--list-item">
                      <a class="op-uc-toc--item-link op-uc-link" href="#111-the-first-h3-heading">
                        <span class="op-uc-toc--list-item-number">1.1.1.</span>
                        <span class="op-uc-toc--list-item-title">The first h3 heading</span>
                      </a>
                    </li>
                  </ul>
                </ul>
                <li class="op-uc-toc--list-item">
                  <a class="op-uc-toc--item-link op-uc-link" href="#2-the-second-h1-heading">
                    <span class="op-uc-toc--list-item-number">2)</span>
                    <span class="op-uc-toc--list-item-title">The second h1 heading</span>
                  </a>
                </li>
                <ul class="op-uc-toc--list">
                  <li class="op-uc-toc--list-item">
                    <a class="op-uc-toc--item-link op-uc-link" href="#21-the-second-h2-heading">
                      <span class="op-uc-toc--list-item-number">2.1)</span>
                      <span class="op-uc-toc--list-item-title">The second h2 heading</span>
                    </a>
                  </li>
                  <ul class="op-uc-toc--list">
                    <li class="op-uc-toc--list-item">
                      <a class="op-uc-toc--item-link op-uc-link" href="#211---the-second-h3-heading">
                        <span class="op-uc-toc--list-item-number">2.1.1</span>
                        <span class="op-uc-toc--list-item-title">- The second h3 heading</span>
                      </a>
                    </li>
                  </ul>
                </ul>
              </ul>
            </nav>
          </p>
          <h1 class="op-uc-h1" id="1-the-first-h1-heading">
            1 The first h1 heading
            <a class="op-uc-link_permalink icon-link op-uc-link" href="#1-the-first-h1-heading" aria-hidden="true"></a>
          </h1>
          <p class="op-uc-p">Some text after the first h1 heading</p>
          <h2 class="op-uc-h2" id="11-the-first-h2-heading">
            1.1 The first h2 heading
            <a class="op-uc-link_permalink icon-link op-uc-link" href="#11-the-first-h2-heading" aria-hidden="true"></a>
          </h2>
          <p class="op-uc-p">Some text after the first h2 heading</p>
          <h3 class="op-uc-h3" id="111-the-first-h3-heading">
            1.1.1. The first h3 heading
            <a class="op-uc-link_permalink icon-link op-uc-link" href="#111-the-first-h3-heading" aria-hidden="true"></a>
          </h3>
          <p class="op-uc-p">Some text after the first h3 heading</p>
          <h1 class="op-uc-h1" id="2-the-second-h1-heading">
            2) The second h1 heading
            <a class="op-uc-link_permalink icon-link op-uc-link" href="#2-the-second-h1-heading" aria-hidden="true"></a>
          </h1>
          <p class="op-uc-p">Some text after the second h1 heading</p>
          <h2 class="op-uc-h2" id="21-the-second-h2-heading">
            2.1) The second h2 heading
            <a class="op-uc-link_permalink icon-link op-uc-link" href="#21-the-second-h2-heading" aria-hidden="true"></a>
          </h2>
          <p class="op-uc-p">Some text after the second h2 heading</p>
          <h3 class="op-uc-h3" id="211---the-second-h3-heading">
            2.1.1 - The second h3 heading
            <a class="op-uc-link_permalink icon-link op-uc-link" href="#211---the-second-h3-heading" aria-hidden="true"></a>
          </h3>
          <p class="op-uc-p">Some text after the second h3 heading</p>
        EXPECTED
      end
    end
  end
end
