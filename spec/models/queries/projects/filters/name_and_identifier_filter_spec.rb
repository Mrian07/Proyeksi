#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Projects::Filters::NameAndIdentifierFilter, type: :model do
  include_context 'filter tests'
  let(:values) { ['A name'] }
  let(:model) { Project }

  it_behaves_like 'basic query filter' do
    let(:class_key) { :name_and_identifier }
    let(:human_name) { 'Name or identifier' }
    let(:type) { :string }
    let(:model) { Project }

    describe '#allowed_values' do
      it 'is nil' do
        expect(instance.allowed_values).to be_nil
      end
    end
  end
end
