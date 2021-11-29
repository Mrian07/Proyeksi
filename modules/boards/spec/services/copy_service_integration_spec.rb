#-- encoding: UTF-8



require 'spec_helper'

describe Projects::CopyService, 'integration', type: :model do
  let(:current_user) do
    FactoryBot.create(:user,
                      member_in_project: source,
                      member_through_role: role)
  end
  let!(:source) { FactoryBot.create :project, enabled_module_names: %w[boards work_package_tracking] }
  let(:query) { board_view.contained_queries.first }
  let(:role) { FactoryBot.create :role, permissions: %i[copy_projects] }
  let(:instance) do
    described_class.new(source: source, user: current_user)
  end
  let(:only_args) { %w[work_packages boards] }
  let(:target_project_params) do
    { name: 'Some name', identifier: 'some-identifier' }
  end
  let(:params) do
    { target_project_params: target_project_params, only: only_args }
  end
  subject { instance.call(params) }
  let(:project_copy) { subject.result }
  let(:board_copies) { Boards::Grid.where(project: project_copy) }
  let(:board_copy) { board_copies.first }

  describe 'for a subproject board' do
    let(:current_user) do
      FactoryBot.create(:user,
                        member_in_projects: [source, child_project],
                        member_through_role: role)
    end
    let!(:child_project) { FactoryBot.create :project, parent: source }
    let!(:board_view) do
      FactoryBot.create :board_grid_with_query,
                        project: source,
                        name: 'Subproject board',
                        options: { "type" => "action", "attribute" => "subproject" }
    end

    before do
      login_as current_user

      # Modify the actual saved query to contain the subproject filter
      query = board_view.contained_queries.first
      query.add_filter('only_subproject_id', '=', child_project.id)
      query.save!
    end

    let(:expected_error) do
      "Widget contained in Grid Board 'Subproject board': Only subproject filter has invalid values."
    end

    it 'will succeed to copy, but add an error for the missing subproject column (Regression #34550)' do
      # Expect to have created to board, but with error
      expect(subject).to be_success
      expect(subject.errors.full_messages).to eq([expected_error])
      expect(board_copies.count).to eq 1

      # Expect board name to match
      expect(board_copy.name).to eq 'Subproject board'

      # Expect the widget to be lost during save
      expect(board_copy.widgets).to be_empty
    end
  end

  describe 'for ordered work packages' do
    let!(:board_view) { FactoryBot.create :board_grid_with_query, project: source, name: 'My Board' }
    let!(:wp_1) { FactoryBot.create(:work_package, project: source, subject: 'Second') }
    let!(:wp_2) { FactoryBot.create(:work_package, project: source, subject: 'First') }

    before do
      ::OrderedWorkPackage.create(query: query, work_package: wp_1, position: 1234)
      ::OrderedWorkPackage.create(query: query, work_package: wp_2, position: -1000)
    end

    describe 'call' do
      it 'will copy the boards with the order correct' do
        expect(subject).to be_success

        expect(board_copies.count).to eq 1

        # Expect board name to match
        expect(board_copy.name).to eq 'My Board'

        # Expect query to differ
        query_id = board_copy.widgets.first.options['queryId']
        expect(query_id.to_i).not_to eq(query.id)

        # Expect query to be in correct project
        query = Query.find(query_id)
        expect(query.project).to eq project_copy

        # Expect widgets have been copied (including updated query references)
        widget = board_view.widgets.first
        widget_copy = board_copy.widgets.first

        different_attr = %w(id grid_id options)
        expect(widget.attributes.except(*different_attr)).to eq widget_copy.attributes.except(*different_attr)

        expect(widget_copy.grid_id).to eq board_copy.id
        expect(widget_copy.options["queryId"]).to eq query.id
        expect(widget_copy.options["filters"]).to eq widget.options["filters"]

        # Expect work packages have been copied in the correct order
        wps = query.ordered_work_packages
        expect(wps.count).to eq 2

        expect(wps[0].work_package.subject).to eq 'First'
        expect(wps[0].position).to eq -1000
        expect(wps[0].work_package.id).not_to eq wp_2.id

        expect(wps[1].work_package.subject).to eq 'Second'
        expect(wps[1].position).to eq 1234
        expect(wps[1].work_package.id).not_to eq wp_1.id
      end
    end
  end
end
