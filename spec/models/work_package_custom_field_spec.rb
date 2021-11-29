

require 'spec_helper'

describe WorkPackageCustomField, type: :model do
  describe '.summable' do
    let!(:list_custom_field) do
      FactoryBot.create(:list_wp_custom_field)
    end
    let!(:int_custom_field) do
      FactoryBot.create(:int_wp_custom_field)
    end
    let!(:float_custom_field) do
      FactoryBot.create(:float_wp_custom_field)
    end

    context 'with a summable field' do
      it 'contains the custom_field' do
        expect(described_class.summable)
          .to match_array [int_custom_field, float_custom_field]
      end
    end
  end
end
