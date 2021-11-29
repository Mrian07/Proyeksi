

require File.dirname(__FILE__) + '/../../spec_helper'

describe Costs::NumberHelper, type: :helper do
  describe '#parse_number_string' do
    context 'with a german local' do
      it 'parses a string with delimiter and separator correctly' do
        I18n.with_locale(:de) do
          expect(helper.parse_number_string("123.456,78"))
            .to eql "123456.78"
        end
      end

      it 'parses a string with space delimiter and separator correctly' do
        I18n.with_locale(:de) do
          expect(helper.parse_number_string("123 456,78"))
            .to eql "123456.78"
        end
      end

      it 'parses a string without delimiter and separator correctly' do
        I18n.with_locale(:de) do
          expect(helper.parse_number_string("12345678"))
            .to eql "12345678"
        end
      end

      it 'parses a string without delimiter and with separator correctly' do
        I18n.with_locale(:de) do
          expect(helper.parse_number_string("123456,78"))
            .to eql "123456.78"
        end
      end

      it 'parses a string with delimiter and without separator correctly' do
        I18n.with_locale(:de) do
          expect(helper.parse_number_string("12.345.678"))
            .to eql "12345678"
        end
      end

      it 'parses a string with space delimiter and without separator correctly' do
        I18n.with_locale(:de) do
          expect(helper.parse_number_string("12 345 678"))
            .to eql "12345678"
        end
      end

      it 'returns alphabetical values instead of a delimiter unchanged' do
        I18n.with_locale(:de) do
          expect(helper.parse_number_string("123456a78"))
            .to eql "123456a78"
        end
      end
    end

    context 'with an english local' do
      it 'parses a string with delimiter and separator correctly' do
        I18n.with_locale(:en) do
          expect(helper.parse_number_string("123,456.78"))
            .to eql "123456.78"
        end
      end

      it 'parses a string with space delimiter and separator correctly' do
        I18n.with_locale(:en) do
          expect(helper.parse_number_string("123 456.78"))
            .to eql "123456.78"
        end
      end

      it 'parses a string without delimiter and separator correctly' do
        I18n.with_locale(:en) do
          expect(helper.parse_number_string("12345678"))
            .to eql "12345678"
        end
      end

      it 'parses a string without delimiter and with separator correctly' do
        I18n.with_locale(:en) do
          expect(helper.parse_number_string("123456.78"))
            .to eql "123456.78"
        end
      end

      it 'parses a string with delimiter and without separator correctly' do
        I18n.with_locale(:en) do
          expect(helper.parse_number_string("12,345,678"))
            .to eql "12345678"
        end
      end

      it 'parses a string with space delimiter and without separator correctly' do
        I18n.with_locale(:en) do
          expect(helper.parse_number_string("12 345 678"))
            .to eql "12345678"
        end
      end

      it 'returns alphabetical values instead of a delimiter unchanged' do
        I18n.with_locale(:en) do
          expect(helper.parse_number_string("123456a78"))
            .to eql "123456a78"
        end
      end
    end

    context 'for nil' do
      it 'is nil' do
        expect(helper.parse_number_string(nil))
          .to be_nil
      end
    end

    context 'with a russian locale (Regression #37859)' do
      it 'parses a string with delimiter and separator correctly' do
        I18n.with_locale(:ru) do
          expect(helper.parse_number_string("123.456,78"))
            .to eql "123456.78"
        end
      end

      it 'parses a string with space delimiter and separator correctly' do
        I18n.with_locale(:de) do
          expect(helper.parse_number_string("123 456,78"))
            .to eql "123456.78"
        end
      end

      it 'parses a string without delimiter and separator correctly' do
        I18n.with_locale(:de) do
          expect(helper.parse_number_string("12345678"))
            .to eql "12345678"
        end
      end

      it 'parses a string without delimiter and with separator correctly' do
        I18n.with_locale(:de) do
          expect(helper.parse_number_string("123456,78"))
            .to eql "123456.78"
        end
      end

      it 'parses a string with delimiter and without separator correctly' do
        I18n.with_locale(:de) do
          expect(helper.parse_number_string("12.345.678"))
            .to eql "12345678"
        end
      end

      it 'parses a string with space delimiter and without separator correctly' do
        I18n.with_locale(:de) do
          expect(helper.parse_number_string("12 345 678"))
            .to eql "12345678"
        end
      end

      it 'returns alphabetical values instead of a delimiter unchanged' do
        I18n.with_locale(:de) do
          expect(helper.parse_number_string("123456a78"))
            .to eql "123456a78"
        end
      end
    end
  end
end
