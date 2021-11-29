

require 'spec_helper'

describe 'Journalized Objects' do
  describe 'journal_editable_by?' do
    context 'when the journable is a work package' do
      let!(:user) { FactoryBot.create(:user, member_in_project: project, member_with_permissions: []) }
      let!(:project) { FactoryBot.create(:project_with_types) }
      let!(:work_package) do
        FactoryBot.create(:work_package,
                          type: project.types.first,
                          author: user,
                          project: project,
                          description: '')
      end

      subject { work_package.journal_editable_by?(work_package.journals.first, user) }

      context 'and the user has no permission to "edit_work_packages"' do
        it { is_expected.to be_falsey }
      end
    end
  end
end
