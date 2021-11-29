

require 'spec_helper'

describe ::API::Decorators::Formattable do
  let(:represented) { 'A **raw** string!' }
  subject { described_class.new(represented).to_json }

  it 'should indicate its format' do
    is_expected.to be_json_eql('markdown'.to_json).at_path('format')
  end

  it 'should contain the raw string' do
    is_expected.to be_json_eql(represented.to_json).at_path('raw')
  end

  it 'should contain the formatted string' do
    is_expected.to be_json_eql('<p class="op-uc-p">A <strong>raw</strong> string!</p>'.to_json).at_path('html')
  end

  context 'passing an object context' do
    let(:object) { FactoryBot.build_stubbed :work_package }
    subject { described_class.new(represented, object: object) }

    it 'passes that to format_text' do
      expect(subject)
        .to receive(:format_text).with(anything, format: :markdown, object: object)
        .and_call_original

      expect(subject.to_json)
        .to be_json_eql('<p class="op-uc-p">A <strong>raw</strong> string!</p>'.to_json).at_path('html')
    end
  end

  context 'format specified explicitly' do
    subject { described_class.new(represented, plain: true).to_json }

    it 'should indicate the explicit format' do
      is_expected.to be_json_eql('plain'.to_json).at_path('format')
    end

    it 'should format using the explicit format' do
      is_expected.to be_json_eql('<p>A **raw** string!</p>'.to_json).at_path('html')
    end
  end
end
