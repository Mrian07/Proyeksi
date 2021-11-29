#-- encoding: UTF-8



require 'spec_helper'
require_relative './expected_markdown'

describe OpenProject::TextFormatting::Formats::Markdown::Formatter do
  it 'should modifiers' do
    assert_html_output(
      '**bold**' => '<strong>bold</strong>',
      'before **bold**' => 'before <strong>bold</strong>',
      '**bold** after' => '<strong>bold</strong> after',
      '**two words**' => '<strong>two words</strong>',
      '**two*words**' => '<strong>two*words</strong>',
      '**two * words**' => '<strong>two * words</strong>',
      '**two** **words**' => '<strong>two</strong> <strong>words</strong>',
      '**(two)** **(words)**' => '<strong>(two)</strong> <strong>(words)</strong>'
    )
  end

  it 'escapes script tags' do
    assert_html_output(
      'this is a <script>' => 'this is a &lt;script&gt;'
    )
  end

  it 'should double dashes should not strikethrough' do
    assert_html_output(
      'double -- dashes -- test' => 'double -- dashes -- test',
      'double -- **dashes** -- test' => 'double -- <strong>dashes</strong> -- test'
    )
  end

  it 'should not mangle brackets' do
    expect(to_html('[msg1][msg2]')).to eq '<p class="op-uc-p">[msg1][msg2]</p>'
  end

  private

  def assert_html_output(to_test, options = {})
    options = { expect_paragraph: true }.merge options
    expect_paragraph = options.delete :expect_paragraph

    to_test.each do |text, expected|
      expected = expect_paragraph ? "<p class=\"op-uc-p\">#{expected}</p>" : expected
      expect(to_html(text, options)).to be_html_eql expected
    end
  end

  def to_html(text, options = {})
    described_class.new(options).to_html(text)
  end
end
