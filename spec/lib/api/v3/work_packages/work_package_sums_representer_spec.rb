

require 'spec_helper'

describe ::API::V3::WorkPackages::WorkPackageSumsRepresenter do
  let(:custom_field) { FactoryBot.build_stubbed(:int_wp_custom_field, id: 1) }
  let(:sums) do
    double('sums',
           story_points: 5,
           remaining_hours: 10,
           estimated_hours: 5,
           material_costs: 5,
           labor_costs: 10,
           overall_costs: 15,
           custom_field_1: 5,
           available_custom_fields: [custom_field])
  end
  let(:schema) { double 'schema', available_custom_fields: [custom_field] }
  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:representer) do
    described_class.create_class(schema, current_user).new(sums)
  end

  subject { representer.to_json }

  context 'estimated_time' do
    it 'is represented' do
      expected = 'PT5H'
      expect(subject).to be_json_eql(expected.to_json).at_path('estimatedTime')
    end
  end

  context 'remainingTime' do
    it 'is represented' do
      expected = 'PT10H'
      expect(subject).to be_json_eql(expected.to_json).at_path('remainingTime')
    end
  end

  context 'storyPoints' do
    it 'is represented' do
      expect(subject).to be_json_eql(sums.story_points.to_json).at_path('storyPoints')
    end
  end

  context 'materialCosts' do
    it 'is represented' do
      expected = "5.00 EUR"
      expect(subject).to be_json_eql(expected.to_json).at_path('materialCosts')
    end
  end

  context 'laborCosts' do
    it 'is represented' do
      expected = "10.00 EUR"
      expect(subject).to be_json_eql(expected.to_json).at_path('laborCosts')
    end
  end

  context 'overallCosts' do
    it 'is represented' do
      expected = "15.00 EUR"
      expect(subject).to be_json_eql(expected.to_json).at_path('overallCosts')
    end
  end

  context 'custom field x' do
    it 'is represented' do
      expect(subject).to be_json_eql(sums.custom_field_1.to_json).at_path('customField1')
    end
  end
end
