

require 'spec_helper'

describe WorkPackages::ReportsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let(:role) do
    FactoryBot.create(:role,
                      permissions: [:view_work_packages])
  end
  let(:member) do
    FactoryBot.create(:member,
                      project: project,
                      principal: user,
                      roles: [role])
  end
  let(:work_package_1) do
    FactoryBot.create(:work_package,
                      id: 21,
                      subject: "Can't print recipes",
                      project: project)
  end
  let(:work_package_2) do
    FactoryBot.create(:work_package,
                      id: 2101,
                      subject: 'Error 281 when updating a recipe',
                      project: project)
  end
  let(:work_package_3) do
    FactoryBot.create(:work_package,
                      id: 2102,
                      project: project)
  end

  before do
    member

    allow(User).to receive(:current).and_return user

    work_package_1
    work_package_2
    work_package_3
  end

  describe '#report' do
    describe 'w/o details' do
      before do
        get :report,
            params: { project_id: project.id }
      end

      subject { response }

      it { is_expected.to be_successful }

      it { is_expected.to render_template('report') }

      it { assigns :work_packages_by_type }

      it { assigns :work_packages_by_version }

      it { assigns :work_packages_by_category }

      it { assigns :work_packages_by_assigned_to }

      it { assigns :work_packages_by_responsible }

      it { assigns :work_packages_by_author }

      it { assigns :work_packages_by_subproject }
    end

    describe 'with details' do
      shared_examples_for 'details view' do
        before do
          get :report_details,
              params: { project_id: project.id, detail: detail }
        end

        subject { response }

        it { is_expected.to be_successful }

        it { is_expected.to render_template('report_details') }

        it { assigns :field }

        it { assigns :rows }

        it { assigns :data }

        it { assigns :report_title }
      end

      describe '#type' do
        let(:detail) { 'type' }

        it_behaves_like 'details view'
      end

      describe '#version' do
        let(:detail) { 'version' }

        it_behaves_like 'details view'
      end

      describe '#priority' do
        let(:detail) { 'priority' }

        it_behaves_like 'details view'
      end

      describe '#category' do
        let(:detail) { 'category' }

        it_behaves_like 'details view'
      end

      describe '#assigned_to' do
        let(:detail) { 'assigned_to' }

        it_behaves_like 'details view'
      end

      describe '#responsible' do
        let(:detail) { 'responsible' }

        it_behaves_like 'details view'
      end

      describe '#author' do
        let(:detail) { 'author' }

        it_behaves_like 'details view'
      end

      describe '#subproject' do
        let(:detail) { 'subproject' }

        it_behaves_like 'details view'
      end

      context 'invalid detail' do
        before do
          get :report_details,
              params: { project_id: project.id, detail: 'invalid' }
        end

        subject { response }

        it { is_expected.to be_redirect }

        it { is_expected.to redirect_to(report_project_work_packages_path(project.identifier)) }
      end
    end
  end
end
