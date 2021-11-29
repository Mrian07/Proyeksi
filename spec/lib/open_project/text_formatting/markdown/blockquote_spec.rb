

require 'spec_helper'
require_relative './expected_markdown'

describe OpenProject::TextFormatting,
         'blockquote' do
  include_context 'expected markdown modules'

  it_behaves_like 'format_text produces' do
    let(:raw) do
      <<~RAW
        John said:
        > Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Maecenas sed libero.
        > Nullam commodo metus accumsan nulla. Curabitur lobortis dui id dolor.
        >
        > * Donec odio lorem,
        > * sagittis ac,
        > * malesuada in,
        > * adipiscing eu, dolor.
        >
        > >Nulla varius pulvinar diam. Proin id arcu id lorem scelerisque condimentum. Proin vehicula turpis vitae lacus.
        >
        > Proin a tellus. Nam vel neque.

        He's right.

        >Second quote
      RAW
    end

    let(:expected) do
      <<~EXPECTED
        <p class="op-uc-p">John said:</p>
        <blockquote class="op-uc-blockquote">
        <p class="op-uc-p">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Maecenas sed libero.<br>
        Nullam commodo metus accumsan nulla. Curabitur lobortis dui id dolor.</p>
        <ul class="op-uc-list">
          <li class="op-uc-list--item">Donec odio lorem,</li>
          <li class="op-uc-list--item">sagittis ac,</li>
          <li class="op-uc-list--item">malesuada in,</li>
          <li class="op-uc-list--item">adipiscing eu, dolor.</li>
        </ul>
        <blockquote class="op-uc-blockquote">
        <p class="op-uc-p">Nulla varius pulvinar diam. Proin id arcu id lorem scelerisque condimentum. Proin vehicula turpis vitae lacus.</p>
        </blockquote>
        <p class="op-uc-p">Proin a tellus. Nam vel neque.</p>
        </blockquote>
        <p class="op-uc-p">He's right.</p>
        <blockquote class="op-uc-blockquote">
        <p class="op-uc-p">Second quote</p>
        </blockquote>
      EXPECTED
    end
  end
end
