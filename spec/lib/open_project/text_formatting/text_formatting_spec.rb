#-- encoding: UTF-8


require 'spec_helper'

describe OpenProject::TextFormatting do
  include OpenProject::TextFormatting

  it 'should markdown formatter' do
    expect(OpenProject::TextFormatting::Formats::Markdown::Formatter).to eq(OpenProject::TextFormatting::Formats.rich_formatter)
    expect(OpenProject::TextFormatting::Formats::Markdown::Helper).to eq(OpenProject::TextFormatting::Formats.rich_helper)
  end

  it 'should plain formatter' do
    expect(OpenProject::TextFormatting::Formats::Plain::Formatter).to eq(OpenProject::TextFormatting::Formats.plain_formatter)
    expect(OpenProject::TextFormatting::Formats::Plain::Helper).to eq(OpenProject::TextFormatting::Formats.plain_helper)
  end

  it 'should link urls and email addresses' do
    raw = <<~DIFF
      This is a sample *text* with a link: http://www.redmine.org
      and an email address foo@example.net
    DIFF

    expected = <<~EXPECTED
      <p>This is a sample *text* with a link: <a href="http://www.redmine.org">http://www.redmine.org</a><br>
      and an email address <a href="mailto:foo@example.net">foo@example.net</a></p>
    EXPECTED

    assert_equal expected.gsub(%r{[\r\n\t]}, ''),
                 OpenProject::TextFormatting::Formats::Plain::Formatter.new({}).to_html(raw).gsub(%r{[\r\n\t]}, '')
  end

  describe 'options' do
    describe '#format' do
      it 'uses format of Settings, if nothing is specified' do
        expect(format_text('_Stars!_')).to be_html_eql('<p class="op-uc-p"><em>Stars!</em></p>')
      end

      it 'allows plain format of options, if specified' do
        expect(format_text('*Stars!*', format: 'plain')).to be_html_eql('<p>*Stars!*</p>')
      end
    end
  end
end
