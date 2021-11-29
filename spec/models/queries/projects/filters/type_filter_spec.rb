#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Projects::Filters::TypeFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :type_id }
    let(:type) { :list }
    let(:model) { Project }
    let(:attribute) { :type_id }
    let(:values) { ['3'] }
    let(:admin) { FactoryBot.build_stubbed(:admin) }
    let(:user) { FactoryBot.build_stubbed(:user) }

    before do
      allow(Type).to receive(:pluck).with(:name, :id).and_return([['Foo', '1234']])
    end

    describe '#allowed_values' do
      it 'is a list of the possible values' do
        expect(instance.allowed_values).to match_array([['Foo', '1234']])
      end
    end
  end
end
