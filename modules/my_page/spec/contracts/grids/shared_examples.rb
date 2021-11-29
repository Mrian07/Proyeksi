#-- encoding: UTF-8



shared_context 'grid contract' do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:instance) { described_class.new(grid, user) }
  let(:default_values) do
    {
      row_count: 6,
      column_count: 7,
      widgets: []
    }
  end
  let(:grid) do
    FactoryBot.build_stubbed(:my_page, default_values)
  end
end

shared_examples_for 'shared grid contract attributes' do
  include_context 'model contract'
  let(:model) { grid }

  describe 'widgets' do
    it_behaves_like 'is writable' do
      let(:attribute) { :widgets }
      let(:value) do
        [
          Grids::Widget.new(start_row: 1,
                            end_row: 4,
                            start_column: 2,
                            end_column: 5,
                            identifier: 'news')
        ]
      end
    end

    context 'invalid identifier' do
      before do
        grid.widgets.build(start_row: 1,
                           end_row: 4,
                           start_column: 2,
                           end_column: 5,
                           identifier: 'bogus_identifier')
      end

      it 'is invalid' do
        expect(instance.validate)
          .to be_falsey
      end

      it 'notes the error' do
        instance.validate
        expect(instance.errors.details[:widgets])
          .to match_array [{ error: :inclusion }]
      end
    end

    context 'collisions between widgets' do
      before do
        grid.widgets.build(start_row: 1,
                           end_row: 3,
                           start_column: 1,
                           end_column: 3,
                           identifier: 'news')
        grid.widgets.build(start_row: 2,
                           end_row: 4,
                           start_column: 2,
                           end_column: 4,
                           identifier: 'documents')
      end

      it 'is invalid' do
        expect(instance.validate)
          .to be_falsey
      end

      it 'notes the error' do
        instance.validate
        expect(instance.errors.details[:widgets])
          .to match_array [{ error: :overlaps }, { error: :overlaps }]
      end
    end

    context 'widgets having the same start column as another\'s end column' do
      before do
        grid.widgets.build(start_row: 1,
                           end_row: 3,
                           start_column: 1,
                           end_column: 3,
                           identifier: 'news')
        grid.widgets.build(start_row: 1,
                           end_row: 3,
                           start_column: 3,
                           end_column: 4,
                           identifier: 'documents')
      end

      it 'is valid' do
        expect(instance.validate)
          .to be_truthy
      end
    end

    context 'widgets having the same start row as another\'s end row' do
      before do
        grid.widgets.build(start_row: 1,
                           end_row: 3,
                           start_column: 1,
                           end_column: 3,
                           identifier: 'news')
        grid.widgets.build(start_row: 3,
                           end_row: 4,
                           start_column: 1,
                           end_column: 3,
                           identifier: 'documents')
      end

      it 'is valid' do
        expect(instance.validate)
          .to be_truthy
      end
    end

    context 'widgets being outside (max) of the grid' do
      before do
        grid.widgets.build(start_row: 1,
                           end_row: grid.row_count + 2,
                           start_column: 1,
                           end_column: 3,
                           identifier: 'news')
      end

      it 'is invalid' do
        expect(instance.validate)
          .to be_falsey
      end

      it 'notes the error' do
        instance.validate
        expect(instance.errors.details[:widgets])
          .to match_array [{ error: :outside }]
      end
    end

    context 'widgets being outside (min) of the grid' do
      before do
        grid.widgets.build(start_row: 1,
                           end_row: 2,
                           start_column: -1,
                           end_column: 3,
                           identifier: 'news')
      end

      it 'is invalid' do
        expect(instance.validate)
          .to be_falsey
      end

      it 'notes the error' do
        instance.validate
        expect(instance.errors.details[:widgets])
          .to match_array [{ error: :outside }]
      end
    end

    context 'widgets spanning the whole grid' do
      before do
        grid.widgets.build(start_row: 1,
                           end_row: grid.row_count + 1,
                           start_column: 1,
                           end_column: grid.column_count + 1,
                           identifier: 'news')
      end

      it 'is valid' do
        expect(instance.validate)
          .to be_truthy
      end
    end

    context 'widgets having start after end column' do
      before do
        grid.widgets.build(start_row: 1,
                           end_row: 2,
                           start_column: 4,
                           end_column: 3,
                           identifier: 'news')
      end

      it 'is invalid' do
        expect(instance.validate)
          .to be_falsey
      end

      it 'notes the error' do
        instance.validate
        expect(instance.errors.details[:widgets])
          .to match_array [{ error: :end_before_start }]
      end
    end

    context 'widgets having start after end row' do
      before do
        grid.widgets.build(start_row: 4,
                           end_row: 2,
                           start_column: 1,
                           end_column: 3,
                           identifier: 'news')
      end

      it 'is invalid' do
        expect(instance.validate)
          .to be_falsey
      end

      it 'notes the error' do
        instance.validate
        expect(instance.errors.details[:widgets])
          .to match_array [{ error: :end_before_start }]
      end
    end

    context 'widgets having start equals end column' do
      before do
        grid.widgets.build(start_row: 1,
                           end_row: 2,
                           start_column: 4,
                           end_column: 3,
                           identifier: 'news')
      end

      it 'is invalid' do
        expect(instance.validate)
          .to be_falsey
      end

      it 'notes the error' do
        instance.validate
        expect(instance.errors.details[:widgets])
          .to match_array [{ error: :end_before_start }]
      end
    end

    context 'widgets having start equals end row' do
      before do
        grid.widgets.build(start_row: 2,
                           end_row: 2,
                           start_column: 1,
                           end_column: 3,
                           identifier: 'news')
      end

      it 'is invalid' do
        expect(instance.validate)
          .to be_falsey
      end

      it 'notes the error' do
        instance.validate
        expect(instance.errors.details[:widgets])
          .to match_array [{ error: :end_before_start }]
      end
    end
  end

  describe 'valid grid subclasses' do
    context 'for a registered subclass' do
      let(:grid) do
        FactoryBot.build_stubbed(:my_page, default_values)
      end

      it 'is valid' do
        expect(instance.validate)
          .to be_truthy
      end
    end

    context 'for the Grid superclass itself' do
      let(:grid) do
        FactoryBot.build_stubbed(:grid, default_values)
      end

      before do
        instance.validate
      end

      it 'is invalid for the grid superclass itself' do
        expect(instance.errors.details[:scope])
          .to match_array [{ error: :inclusion }]
      end
    end
  end
end
