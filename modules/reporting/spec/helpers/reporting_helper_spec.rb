

require 'spec_helper'

describe ReportingHelper, type: :helper do
  describe '#field_representation_map' do
    context 'for a custom field' do
      context 'for which a custom option exists (e.g. a list field)' do
        let(:custom_field) do
          FactoryBot.create(
            :list_wp_custom_field,
            name: "Ingredients",
            possible_values: ["ham"]
          )
        end

        it 'returns the option value' do
          option = custom_field.possible_values.first

          expect(field_representation_map("custom_field#{custom_field.id}", option.id))
            .to eql 'ham'
        end

        it 'returns not found for an outdated value value' do
          expect(field_representation_map("custom_field#{custom_field.id}", "1234123"))
            .to eql '1234123 not found'
        end
      end

      context 'for which no custom option exists (e.g. a float field)' do
        let(:custom_field) do
          FactoryBot.create(
            :float_wp_custom_field,
            name: "Estimate"
          )
        end

        it 'returns the option value' do
          expect(field_representation_map("custom_field#{custom_field.id}", 3.0))
            .to eql 3.0
        end
      end
    end

    context 'for which no custom option exists' do
      it 'returns the not found value' do
        expect(field_representation_map("custom_field12345", "345"))
          .to eql "345 not found"
      end
    end
  end
end
