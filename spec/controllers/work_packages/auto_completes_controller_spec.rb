

require 'spec_helper'

describe WorkPackages::AutoCompletesController, type: :controller do
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
                      subject: "Can't print recipes",
                      project: project)
  end

  let(:work_package_2) do
    FactoryBot.create(:work_package,
                      subject: 'Error when updating a recipe',
                      project: project)
  end

  let(:work_package_3) do
    FactoryBot.create(:work_package,
                      subject: 'Lorem ipsum',
                      project: project)
  end

  before do
    member

    allow(User).to receive(:current).and_return user

    work_package_1
    work_package_2
    work_package_3
  end

  shared_examples_for 'successful response' do
    subject { response }

    it { is_expected.to be_successful }
  end

  shared_examples_for 'contains expected values' do
    subject { assigns(:work_packages) }

    it { is_expected.to include(*expected_values) }
  end

  describe '#work_packages' do
    describe 'search is case insensitive' do
      let(:expected_values) { [work_package_1, work_package_2] }

      before do
        get :index,
            params: {
              project_id: project.id,
              q: 'ReCiPe'
            },
            format: :json
      end

      it_behaves_like 'successful response'

      it_behaves_like 'contains expected values'
    end

    describe 'returns work package for given id' do
      let(:expected_values) { work_package_1 }

      before do
        get :index,
            params: {
              project_id: project.id,
              q: work_package_1.id
            },
            format: :json
      end

      it_behaves_like 'successful response'

      it_behaves_like 'contains expected values'
    end

    describe 'returns work package for given id' do
      # this relies on all expected work packages to have ids that contain the given string
      # we do not want to have work_package_3 so we take it's id + 1 to create a string
      # we are sure to not be part of work_package_3's id.
      let(:ids) do
        taken_ids = WorkPackage.pluck(:id).map(&:to_s)

        id = work_package_3.id + 1

        while taken_ids.include?(id.to_s) || work_package_3.id.to_s.include?(id.to_s)
          id = id + 1
        end

        id.to_s
      end

      let!(:expected_values) do
        expected = [work_package_1, work_package_2]

        WorkPackage.pluck(:id)

        expected_return = []
        expected.each do |wp|
          new_id = wp.id.to_s + ids
          WorkPackage.where(id: wp.id).update_all(id: new_id)
          expected_return << WorkPackage.find(new_id)
        end

        expected_return
      end

      before do
        get :index,
            params: {
              project_id: project.id,
              q: ids
            },
            format: :json
      end

      it_behaves_like 'successful response'

      it_behaves_like 'contains expected values'

      context 'uniq' do
        let(:assigned) { assigns(:work_packages) }

        subject { assigned.size }

        it { is_expected.to eq(assigned.uniq.size) }
      end
    end

    describe 'returns work package for given id' do
      render_views
      let(:work_package_4) do
        FactoryBot.create(:work_package,
                          subject: "<script>alert('danger!');</script>",
                          project: project)
      end
      let(:expected_values) { work_package_4 }

      before do
        get :index,
            params: {
              project_id: project.id,
              q: work_package_4.id
            },
            format: :json
      end

      it_behaves_like 'successful response'
      it_behaves_like 'contains expected values'

      it 'should escape html' do
        expect(response.body).not_to include '<script>'
      end
    end

    describe 'in different projects' do
      let(:project_2) do
        FactoryBot.create(:project,
                          parent: project)
      end
      let(:member_2) do
        FactoryBot.create(:member,
                          project: project_2,
                          principal: user,
                          roles: [role])
      end
      let(:work_package_4) do
        FactoryBot.create(:work_package,
                          subject: 'Foo Bar Baz',
                          project: project_2)
      end

      before do
        member_2

        work_package_4

        get :index,
            params: {
              project_id: project.id,
              q: work_package_4.id
            },
            format: :json
      end

      let(:expected_values) { work_package_4 }

      it_behaves_like 'successful response'

      it_behaves_like 'contains expected values'
    end
  end
end
