

require 'spec_helper'

describe CustomOption, type: :model do
  let(:custom_field) do
    cf = FactoryBot.build(:wp_custom_field, field_format: 'list')
    cf.custom_options.build(value: 'some value')

    cf
  end

  let(:custom_option) { custom_field.custom_options.first }

  before do
    custom_field.save!
  end

  describe 'saving' do
    it "updates the custom_field's timestamp" do
      timestamp_before = custom_field.updated_at
      sleep 1
      custom_option.touch
      expect(custom_field.reload.updated_at).not_to eql(timestamp_before)
    end
  end

  describe '.destroy' do
    context 'with more than one option for the cf' do
      before do
        FactoryBot.create(:custom_option, custom_field: custom_field)
      end

      it 'removes the option' do
        custom_option.destroy

        expect(CustomOption.where(id: custom_option.id).count)
          .to eql 0
      end

      it "updates the custom_field's timestamp" do
        timestamp_before = custom_field.updated_at
        sleep 1
        custom_option.destroy
        expect(custom_field.reload.updated_at).not_to eql(timestamp_before)
      end
    end

    context 'with only one option for the cf' do
      before do
        custom_option.destroy
      end

      it 'reports an error' do
        expect(custom_option.errors[:base])
          .to match_array [I18n.t(:'activerecord.errors.models.custom_field.at_least_one_custom_option')]
      end

      it 'does not remove the custom option' do
        expect(CustomOption.where(id: custom_option.id).count)
          .to eql 1
      end
    end
  end
end
