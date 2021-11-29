

require 'spec_helper'

describe JournalsController, type: :controller do
  let(:user) { FactoryBot.create(:user, member_in_project: project, member_through_role: role) }
  let(:project) { FactoryBot.create(:project_with_types) }
  let(:role) { FactoryBot.create(:role, permissions: permissions) }
  let(:member) do
    FactoryBot.build(:member, project: project,
                              roles: [role],
                              principal: user)
  end
  let(:work_package) do
    FactoryBot.build(:work_package, type: project.types.first,
                                    author: user,
                                    project: project,
                                    description: '')
  end
  let(:journal) do
    FactoryBot.create(:work_package_journal,
                      journable: work_package,
                      user: user)
  end
  let(:permissions) { [:view_work_packages] }

  before do
    allow(User).to receive(:current).and_return user
  end

  describe 'GET diff' do
    render_views

    let(:params) { { id: work_package.journals.last.id.to_s, field: :description, format: 'js' } }

    before do
      work_package.update_attribute :description, 'description'

      get :diff,
          xhr: true,
          params: params
    end

    describe 'w/ authorization' do
      it 'should be successful' do
        expect(response).to be_successful
      end

      it 'should present the diff correctly' do
        expect(response.body.strip).to eq("<div class=\"text-diff\">\n  <label class=\"hidden-for-sighted\">Begin of the insertion</label><ins class=\"diffmod\">description</ins><label class=\"hidden-for-sighted\">End of the insertion</label>\n</div>")
      end
    end

    describe 'w/o authorization' do
      let(:permissions) { [] }
      it { expect(response).not_to be_successful }
    end
  end
end
