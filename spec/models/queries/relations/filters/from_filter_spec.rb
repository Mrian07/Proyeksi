#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Relations::Filters::FromFilter, type: :model do
  include_context 'filter tests'
  let(:values) { ['1'] }
  let(:model) { Relation }
  let(:current_user) { FactoryBot.build_stubbed(:user) }

  it_behaves_like 'basic query filter' do
    let(:class_key) { :from_id }
    let(:type) { :integer }
    # The name is not very good but as long as the filter is not displayed in the UI ...
    let(:human_name) { 'Work package' }

    describe '#allowed_values' do
      it 'is nil' do
        expect(instance.allowed_values).to be_nil
      end
    end
  end

  describe '#visibility_checked?' do
    it 'is true' do
      expect(instance).to be_visibility_checked
    end
  end

  describe '#scope' do
    before do
      login_as(current_user)
    end
    let(:visible_sql) { WorkPackage.visible(current_user).select(:id).to_sql }

    context 'for "="' do
      let(:operator) { '=' }

      it 'is the same as handwriting the query' do
        expected = model.where("from_id IN ('1') AND to_id IN (#{visible_sql})")

        expect(instance.scope.to_sql).to eql expected.to_sql
      end
    end

    context 'for "!"' do
      let(:operator) { '!' }

      it 'is the same as handwriting the query' do
        expected = model.where("from_id NOT IN ('1') AND to_id IN (#{visible_sql})")

        expect(instance.scope.to_sql).to eql expected.to_sql
      end
    end
  end
end
