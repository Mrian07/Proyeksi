

require 'spec_helper'

require_relative './shared_model'

describe Grids::MyPage, type: :model do
  let(:instance) { described_class.new(row_count: 5, column_count: 5) }
  let(:user) { FactoryBot.build_stubbed(:user) }

  it_behaves_like 'grid attributes'

  context 'attributes' do
    it '#user' do
      instance.user = user
      expect(instance.user)
        .to eql user
    end
  end

  context 'altering widgets' do
    context 'when removing a work_packages_table widget' do
      let(:user) { FactoryBot.create(:user) }
      let(:query) do
        FactoryBot.create(:query,
                          user: user,
                          hidden: true)
      end

      before do
        widget = Grids::Widget.new(identifier: 'work_packages_table',
                                   start_row: 1,
                                   end_row: 2,
                                   start_column: 1,
                                   end_column: 2,
                                   options: { queryId: query.id })

        instance.widgets = [widget]
        instance.save!
      end

      it 'removes the widget\'s query' do
        instance.widgets = []

        expect(Query.find_by(id: query.id))
          .to be_nil
      end
    end
  end
end
