

require 'spec_helper'

describe Queries::WorkPackages::Filter::CustomFieldFilter,
         'with contains filter (Regression test #28348)',
         type: :model do
  let(:cf_accessor) { "cf_#{custom_field.id}" }
  let(:query) { FactoryBot.build_stubbed(:query, project: project) }
  let(:instance) do
    described_class.create!(name: cf_accessor, operator: operator, values: %w(foo), context: query)
  end

  let(:project) do
    FactoryBot.create :project,
                      types: [type],
                      work_package_custom_fields: [custom_field]
  end
  let(:custom_field) do
    FactoryBot.create(:text_issue_custom_field, name: 'LongText')
  end
  let(:type) { FactoryBot.create(:type_standard, custom_fields: [custom_field]) }

  let!(:wp_contains) do
    FactoryBot.create :work_package,
                      type: type,
                      project: project,
                      custom_values: { custom_field.id => 'foo' }
  end
  let!(:wp_not_contains) do
    FactoryBot.create :work_package,
                      type: type,
                      project: project,
                      custom_values: { custom_field.id => 'bar' }
  end

  let!(:wp_empty) do
    FactoryBot.create :work_package,
                      type: type,
                      project: project,
                      custom_values: { custom_field.id => '' }
  end

  let!(:wp_nil) do
    FactoryBot.create :work_package,
                      type: type,
                      project: project,
                      custom_values: { custom_field.id => nil }
  end

  subject { WorkPackage.where(instance.where) }

  describe 'contains' do
    let(:operator) { '~' }

    it 'returns the one matching work package' do
      is_expected
        .to match_array [wp_contains]
    end
  end

  describe 'not contains' do
    let(:operator) { '!~' }

    it 'returns the three non-matching work package' do
      is_expected
        .to match_array [wp_not_contains, wp_empty, wp_nil]
    end
  end
end
