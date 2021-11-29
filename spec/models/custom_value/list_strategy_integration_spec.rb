

require 'spec_helper'

describe CustomValue::ListStrategy, 'integration tests' do
  let(:type) { FactoryBot.create :type }
  let(:project) { FactoryBot.create :project, types: [type] }
  let!(:custom_field) do
    FactoryBot.create(
      :list_wp_custom_field,
      name: "Invalid List CF",
      multi_value: true,
      types: [type],
      projects: [project],
      possible_values: ['A', 'B']
    )
  end

  let!(:work_package) do
    FactoryBot.create :work_package,
                      project: project,
                      type: type,
                      custom_values: { custom_field.id => custom_field.custom_options.find_by(value: 'A') }
  end

  it 'can handle invalid CustomOptions (Regression test)' do
    expect(work_package.public_send(:"custom_field_#{custom_field.id}")).to eq(%w(A))

    # Remove the custom value without replacement
    CustomValue.find_by(customized_id: work_package.id).update_columns(value: 'invalid')
    work_package.reload
    work_package.reset_custom_values!

    expect(work_package.public_send(:"custom_field_#{custom_field.id}")).to eq(['invalid not found'])
  end
end
