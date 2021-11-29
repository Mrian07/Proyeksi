#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Users::Filters::StatusFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :status }
    let(:type) { :list }

    describe '#allowed_values' do
      it 'is a list of the possible values' do
        expected = Principal.statuses.keys.map do |key|
          [I18n.t(:"status_#{key}"), key]
        end

        expect(instance.allowed_values).to match_array(expected)
      end
    end
  end

  describe '#scope' do
    include_context 'filter tests'
    let(:values) { %w[active invited] }
    let(:model) { User.user }

    context 'for "="' do
      let(:operator) { '=' }

      it 'is the same as handwriting the query' do
        expected = model.where("users.status IN (1,4)")

        expect(instance.scope.to_sql).to eql expected.to_sql
      end
    end
  end
end
