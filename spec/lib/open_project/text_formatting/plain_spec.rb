#-- encoding: UTF-8



require 'spec_helper'

describe OpenProject::TextFormatting::Formats::Plain::Formatter do
  subject { described_class.new({}) }

  it 'should plain text' do
    assert_html_output('This is some input' => 'This is some input')
  end

  it 'should escaping' do
    assert_html_output(
      'this is a <script>' => 'this is a &lt;script&gt;'
    )
  end

  private

  def assert_html_output(to_test, expect_paragraph = true)
    to_test.each do |text, expected|
      assert_equal((expect_paragraph ? "<p>#{expected}</p>" : expected), subject.to_html(text),
                   "Formatting the following text failed:\n===\n#{text}\n===\n")
    end
  end

  def to_html(text)
    subject.to_html(text)
  end
end
