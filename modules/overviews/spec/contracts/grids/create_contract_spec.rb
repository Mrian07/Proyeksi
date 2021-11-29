#-- encoding: UTF-8



require 'spec_helper'

describe Grids::CreateContract, 'for Grids::Overview' do
  let(:project) do
    FactoryBot.build_stubbed(:project).tap do |p|
      allow(Project)
        .to receive(:find)
        .with(p.identifier)
        .and_return(p)
    end
  end
  let(:permissions) { %i[manage_overview] }
  let(:current_user) do
    FactoryBot.build_stubbed(:user).tap do |u|
      allow(u)
        .to receive(:allowed_to?) do |permission, permission_project|
          permissions.include?(permission) && permission_project == project
        end
    end
  end
  let(:grid) do
    scope = OpenProject::StaticRouting::StaticUrlHelpers.new.project_overview_path(project)
    ::Grids::Factory.build(scope, current_user)
  end
  include_context 'model contract'

  let(:instance) { described_class.new(grid, current_user) }

  describe 'user_id' do
    it_behaves_like 'is not writable' do
      let(:attribute) { :user_id }
      let(:value) { 5 }
    end
  end

  describe 'project_id' do
    it_behaves_like 'is writable' do
      let(:attribute) { :project_id }
      let(:value) { 5 }
    end
  end

  context 'if an overview grid already exists for the project' do
    before do
      scope = double('grid exists scope')

      allow(Grids::Overview)
        .to receive(:where)
        .with(project_id: project.id)
        .and_return scope

      allow(scope)
        .to receive(:exists?)
        .and_return(true)
    end

    it 'reports an error on scope' do
      instance.validate

      expect(instance.errors.symbols_for(:scope))
        .to match_array [:taken]
    end
  end

  context 'if the user lacks :manage_overview permission' do
    let(:permissions) { [] }

    before do
      # Have to remove the widgets (members, work_package_overview) that is not allowed to the user
      # as the necessary permission is lacking.
      grid.widgets = grid.widgets.reject { |w| %w(members work_packages_overview).include?(w.identifier) }
    end

    context 'if the grid does not have any changes compared to the default' do
      it 'is valid' do
        expect(instance.validate)
          .to be_truthy
      end
    end

    context 'if the grid has changes compared to the default' do
      context '(row_count)' do
        before do
          grid.row_count += 1
        end

        it 'reports an error on row_count' do
          instance.validate

          expect(instance.errors.symbols_for(:row_count))
            .to match_array [:unchangeable]
        end
      end

      context '(column_count)' do
        before do
          grid.column_count += 1
        end

        it 'reports an error on row_count' do
          instance.validate

          expect(instance.errors.symbols_for(:column_count))
            .to match_array [:unchangeable]
        end
      end

      context '(widget added)' do
        before do
          grid.row_count = 4
          grid.widgets.build(identifier: 'project_details',
                             start_row: 3,
                             end_row: 4,
                             start_column: 1,
                             end_column: 3,
                             options: {
                               name: I18n.t('js.grid.widgets.work_packages_overview.title')
                             })
        end

        it 'reports an error on widgets' do
          instance.validate

          expect(instance.errors.symbols_for(:widgets))
            .to match_array [:unchangeable]
        end
      end

      context '(widget altered)' do
        before do
          grid.row_count = 4
          grid.widgets.last.end_row += 1
        end

        it 'reports an error on widgets' do
          instance.validate

          expect(instance.errors.symbols_for(:widgets))
            .to match_array [:unchangeable]
        end
      end

      context '(widget options altered)' do
        before do
          grid.widgets[0].options = { name: 'My own name' }
        end

        it 'reports an error on widgets' do
          instance.validate

          expect(instance.errors.symbols_for(:widgets))
            .to match_array [:unchangeable]
        end
      end
    end
  end
end
