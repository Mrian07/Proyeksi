#-- encoding: UTF-8



require 'spec_helper'

describe Grids::Filters::ScopeFilter, type: :model do
  include_context 'filter tests'
  let(:values) { ['/my/page'] }
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:model) { Grids::Grid }

  before do
    login_as(user)
  end

  it_behaves_like 'basic query filter' do
    let(:class_key) { :scope }
    let(:type) { :list }
    let(:model) { Grids::Grid.where(user_id: user.id) }
    let(:values) { ['/my/page'] }
  end

  describe '#scope' do
    context 'for "="' do
      let(:operator) { '=' }

      context 'for /my/page do' do
        it 'is the same as handwriting the query' do
          expected = model.where("(grids.type IN ('Grids::MyPage'))")

          expect(instance.scope.to_sql).to eql expected.to_sql
        end
      end
    end
  end
end
