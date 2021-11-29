#-- encoding: UTF-8



shared_context 'grid contract' do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:instance) { described_class.new(grid, user) }
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:default_values) do
    {
      row_count: 6,
      column_count: 7,
      widgets: [],
      project: project
    }
  end
  let(:grid) do
    FactoryBot.build_stubbed(:dashboard, default_values)
  end
  let(:mange_allowed) { true }
  let(:permissions) { %i[manage_dashboards save_queries manage_public_queries] }

  before do
    allow(user)
      .to receive(:allowed_to?) do |permission, context|
      project == context && permissions.include?(permission)
    end
  end
end

shared_examples_for 'shared grid contract attributes' do
  include_context 'model contract'
  let(:model) { grid }

  it 'is valid' do
    expect(instance.validate)
      .to be_truthy
  end

  context 'if not having the manage_dashbaords permission' do
    let(:permissions) { %i[save_queries] }

    it 'is invalid' do
      expect(instance.validate)
        .to be_falsey
    end

    it 'notes the error' do
      instance.validate
      expect(instance.errors.details[:scope])
        .to match_array [{ error: :inclusion }]
    end
  end

  describe 'widgets' do
    it_behaves_like 'is writable' do
      let(:attribute) { :widgets }
      let(:value) do
        [
          Grids::Widget.new(start_row: 1,
                            end_row: 4,
                            start_column: 2,
                            end_column: 5,
                            identifier: 'work_packages_table')
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
                           identifier: 'work_packages_table')
        grid.widgets.build(start_row: 2,
                           end_row: 4,
                           start_column: 2,
                           end_column: 4,
                           identifier: 'work_packages_table')
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
                           identifier: 'work_packages_table')
        grid.widgets.build(start_row: 1,
                           end_row: 3,
                           start_column: 3,
                           end_column: 4,
                           identifier: 'work_packages_table')
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
                           identifier: 'work_packages_table')
        grid.widgets.build(start_row: 3,
                           end_row: 4,
                           start_column: 1,
                           end_column: 3,
                           identifier: 'work_packages_table')
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
                           identifier: 'work_packages_table')
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
                           identifier: 'work_packages_table')
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
                           identifier: 'work_packages_table')
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
                           identifier: 'work_packages_table')
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
                           identifier: 'work_packages_table')
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
                           identifier: 'work_packages_table')
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
                           identifier: 'work_packages_table')
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
end
