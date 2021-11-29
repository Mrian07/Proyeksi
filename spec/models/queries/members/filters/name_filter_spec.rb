#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Members::Filters::NameFilter, type: :model do
  include_context 'filter tests'
  let(:values) { ['A name'] }
  let(:model) { Member.joins(:principal) }

  it_behaves_like 'basic query filter' do
    let(:class_key) { :name }
    let(:type) { :string }
    let(:model) { Member.joins(:principal) }

    describe '#allowed_values' do
      it 'is nil' do
        expect(instance.allowed_values).to be_nil
      end
    end
  end

  describe '#scope' do
    before do
      allow(Setting)
        .to receive(:user_format)
        .and_return(:firstname)
    end

    context 'for "="' do
      let(:operator) { '=' }

      it 'is the same as handwriting the query' do
        expected = model.where("LOWER(users.firstname) IN ('#{values.first.downcase}')")

        expect(instance.scope.to_sql).to eql expected.to_sql
      end
    end

    context 'for "!"' do
      let(:operator) { '!' }

      it 'is the same as handwriting the query' do
        expected = model.where("LOWER(users.firstname) NOT IN ('#{values.first.downcase}')")

        expect(instance.scope.to_sql).to eql expected.to_sql
      end
    end

    context 'for "~"' do
      let(:operator) { '~' }

      it 'is the same as handwriting the query' do
        expected = model.where("LOWER(users.firstname) LIKE '%#{values.first.downcase}%'")

        expect(instance.scope.to_sql).to eql expected.to_sql
      end
    end

    context 'for "!~"' do
      let(:operator) { '!~' }

      it 'is the same as handwriting the query' do
        expected = model.where("LOWER(users.firstname) NOT LIKE '%#{values.first.downcase}%'")

        expect(instance.scope.to_sql).to eql expected.to_sql
      end
    end
  end
end
