

require 'spec_helper'

describe WorkPackage, type: :model do
  let(:type) { FactoryBot.create :type }
  let(:project) { FactoryBot.create :project, types: [type] }

  let(:custom_field) do
    FactoryBot.create(
      :list_wp_custom_field,
      name: "Ingredients",
      multi_value: true,
      types: [type],
      projects: [project],
      possible_values: ["ham", "onions", "pineapple", "mushrooms"]
    )
  end

  let(:custom_values) do
    custom_field
      .custom_options
      .where(value: ["ham", "onions", "pineapple"])
      .pluck(:id)
      .map(&:to_s)
  end

  let(:work_package) do
    wp = FactoryBot.create :work_package, project: project, type: type
    wp.reload
    wp.custom_field_values = {
      custom_field.id => custom_values
    }
    wp.save
    wp
  end

  let(:values) { work_package.custom_value_for(custom_field) }
  let(:typed_values) { work_package.typed_custom_value_for(custom_field.id) }

  it 'returns the properly typed values' do
    expect(values.map { |cv| cv.value }).to eq(custom_values)
    expect(typed_values).to eq(%w(ham onions pineapple))
  end

  context 'when value not present' do
    let(:work_package) { FactoryBot.create :work_package, project: project, type: type }

    it 'returns nil properly' do
      expect(values).to eq(nil)
      expect(typed_values).to eq(nil)
    end
  end

  describe 'setting and reading values' do
    shared_examples_for 'custom field values updates' do
      before do
        # Reload to reset i.e. the saved_changes filter on custom_values
        work_package.reload
      end

      it 'touches the work_package' do
        expect do
          work_package.custom_field_values = { custom_field.id => ids }
          work_package.save
        end
          .to(change { work_package.lock_version })
      end

      it 'sets the values' do
        work_package.custom_field_values = { custom_field.id => ids }
        work_package.save

        expect(work_package.send("custom_field_#{custom_field.id}"))
          .to eql values
      end
    end

    context 'when removing some custom values' do
      it_behaves_like 'custom field values updates' do
        let(:ids) { [custom_values.first.to_s] }
        let(:values) { ['ham'] }
      end
    end

    context 'when removing all custom values' do
      it_behaves_like 'custom field values updates' do
        let(:ids) { [] }
        let(:values) { [nil] }
      end
    end

    context 'when adding values' do
      it_behaves_like 'custom field values updates' do
        let(:ids) do
          CustomOption.where(value: ["ham", "onions", "pineapple", "mushrooms"]).pluck(:id).map(&:to_s)
        end
        let(:values) { ["ham", "onions", "pineapple", "mushrooms"] }
      end
    end

    context 'when first having no values and then adding some' do
      let(:custom_values) { [] }

      it_behaves_like 'custom field values updates' do
        let(:ids) do
          CustomOption.where(value: ["ham", "mushrooms"]).pluck(:id).map(&:to_s)
        end
        let(:values) { ["ham", "mushrooms"] }
      end
    end
  end
end
