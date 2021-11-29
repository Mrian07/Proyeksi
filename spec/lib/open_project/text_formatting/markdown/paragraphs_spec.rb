

require 'spec_helper'
require_relative './expected_markdown'

describe OpenProject::TextFormatting,
         'paragraphs' do
  include_context 'expected markdown modules'

  it_behaves_like 'format_text produces' do
    let(:raw) do
      <<~RAW
        Some text

        More text
      RAW
    end

    let(:expected) do
      <<~EXPECTED
        <p class="op-uc-p">Some text</p>
        <p class="op-uc-p">More text</p>
      EXPECTED
    end
  end
end
