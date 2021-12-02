#-- encoding: UTF-8



require 'spec_helper'

describe ProyeksiApp::TextFormatting::Formats::Markdown::PandocWrapper do
  let(:subject) { described_class.new }

  before do
    allow(subject).to receive(:read_usage_string).and_return(usage_string)
  end

  describe 'wrap mode' do
    context 'when wrap=preserve exists' do
      let(:usage_string) do
        <<~EOS
                                --list-output-formats#{'                           '}
                                --list-highlight-languages#{'                      '}
                                --list-highlight-styles#{'                         '}
                                --wrap=auto|none|preserve
          -v                    --version#{'                                       '}
          -h                    --help
        EOS
      end

      it do
        expect(subject.wrap_mode).to eq('--wrap=preserve')
      end
    end

    context 'when only no-wrap exists' do
      let(:usage_string) do
        <<~EOS
                                --list-output-formats#{'                           '}
                                --list-highlight-languages#{'                      '}
                                --list-highlight-styles#{'                         '}
                                --no-wrap
          -v                    --version#{'                                       '}
          -h                    --help
        EOS
      end
      it do
        expect(subject.wrap_mode).to eq('--no-wrap')
      end
    end

    context 'when neither exists' do
      let(:usage_string) { 'wat?' }
      it do
        expect do
          subject.wrap_mode
        end.to raise_error 'Your pandoc version has neither --no-wrap nor --wrap=preserve. Please install a recent version of pandoc.'
      end
    end
  end
end
