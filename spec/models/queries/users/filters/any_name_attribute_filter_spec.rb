#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Users::Filters::AnyNameAttributeFilter, type: :model do
  include_context 'filter tests'
  let(:values) { ['A name'] }
  let(:model) { User.user }
  let(:filter_str) { instance.send :sql_concat_name }

  it_behaves_like 'basic query filter' do
    let(:class_key) { :any_name_attribute }
    let(:type) { :string }
    let(:model) { User.user }

    describe '#allowed_values' do
      it 'is nil' do
        expect(instance.allowed_values).to be_nil
      end
    end

    describe '#available_operators' do
      it 'supports = and !' do
        expect(instance.available_operators)
          .to eql [Queries::Operators::Contains, Queries::Operators::NotContains]
      end
    end
  end

  describe '#scope' do
    context 'for "~"' do
      let(:operator) { '~' }

      it 'is the same as handwriting the query' do
        expected = model.where("#{filter_str} LIKE '%#{values.first.downcase}%'")

        expect(instance.scope.to_sql).to eql expected.to_sql
      end
    end

    context 'for "!~"' do
      let(:operator) { '!~' }

      it 'is the same as handwriting the query' do
        expected = model.where("#{filter_str} NOT LIKE '%#{values.first.downcase}%'")

        expect(instance.scope.to_sql).to eql expected.to_sql
      end
    end
  end
end
