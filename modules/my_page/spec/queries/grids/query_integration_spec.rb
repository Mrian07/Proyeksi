

require 'spec_helper'

describe Grids::Query, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let!(:my_page_grid) do
    FactoryBot.create(:my_page, user: user)
  end
  let!(:other_my_page_grid) do
    FactoryBot.create(:my_page, user: other_user)
  end
  let(:instance) { described_class.new }

  before do
    login_as(user)
  end

  context 'without a filter' do
    describe '#results' do
      it 'is the same as getting all the grids visible to the user' do
        expect(instance.results).to match_array [my_page_grid]
      end
    end
  end

  context 'with a scope filter' do
    before do
      instance.where('scope', '=', ['/my/page'])
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expect(instance.results).to match_array [my_page_grid]
      end
    end

    describe '#valid?' do
      it 'is true' do
        expect(instance).to be_valid
      end

      it 'is invalid if the filter is invalid' do
        instance.where('scope', '!', ['/some/other/page'])
        expect(instance).to be_invalid
      end
    end
  end
end
