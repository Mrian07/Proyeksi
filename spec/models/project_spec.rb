

require 'spec_helper'
require File.expand_path('../support/shared/become_member', __dir__)

describe Project, type: :model do
  include BecomeMember
  shared_let(:admin) { FactoryBot.create :admin }

  let(:active) { true }
  let(:project) { FactoryBot.create(:project, active: active) }
  let(:build_project) { FactoryBot.build_stubbed(:project, active: active) }
  let(:user) { FactoryBot.create(:user) }

  describe '#active?' do
    context 'if active' do
      it 'is true' do
        expect(project).to be_active
      end
    end

    context 'if not active' do
      let(:active) { false }

      it 'is false' do
        expect(project).not_to be_active
      end
    end
  end

  describe '#archived?' do
    context 'if active' do
      it 'is true' do
        expect(project).not_to be_archived
      end
    end

    context 'if not active' do
      let(:active) { false }

      it 'is false' do
        expect(project).to be_archived
      end
    end
  end

  context 'when the wiki module is enabled' do
    let(:project) { FactoryBot.create(:project, disable_modules: 'wiki') }

    before :each do
      project.enabled_module_names = project.enabled_module_names | ['wiki']
      project.save
      project.reload
    end

    it 'creates a wiki' do
      expect(project.wiki).to be_present
    end

    it 'creates a wiki menu item named like the default start page' do
      expect(project.wiki.wiki_menu_items).to be_one
      expect(project.wiki.wiki_menu_items.first.title).to eq(project.wiki.start_page)
    end
  end

  describe '#copy_allowed?' do
    let(:user) { FactoryBot.build_stubbed(:user) }
    let(:project) { FactoryBot.build_stubbed(:project) }
    let(:permission_granted) { true }

    before do
      allow(user)
        .to receive(:allowed_to?)
        .with(:copy_projects, project)
        .and_return(permission_granted)

      login_as(user)
    end

    context 'with copy project permission' do
      it 'is true' do
        expect(project.copy_allowed?).to be_truthy
      end
    end

    context 'without copy project permission' do
      let(:permission_granted) { false }

      it 'is false' do
        expect(project.copy_allowed?).to be_falsey
      end
    end
  end

  describe 'status' do
    let(:status) { FactoryBot.build_stubbed(:project_status) }
    let(:stubbed_project) do
      FactoryBot.build_stubbed(:project,
                               status: status)
    end

    it 'has a status' do
      expect(stubbed_project.status)
        .to eql status
    end

    it 'is destroyed along with the project' do
      status = project.create_status explanation: 'some description'

      project.destroy!

      expect(Projects::Status.where(id: status.id))
        .not_to exist
    end
  end

  describe 'name' do
    let(:name) { '     Hello    World   ' }
    let(:project) { described_class.new FactoryBot.attributes_for(:project, name: name) }

    context 'with white spaces in the name' do
      it 'trims the name' do
        project.save
        expect(project.name).to eql('Hello World')
      end
    end

    context 'when updating the name' do
      it 'persists the update' do
        project.save
        project.name = 'A new name'
        project.save
        project.reload

        expect(project.name).to eql('A new name')
      end
    end
  end

  describe '#types_used_by_work_packages' do
    let(:project) { FactoryBot.create(:project_with_types) }
    let(:type) { project.types.first }
    let(:other_type) { FactoryBot.create(:type) }
    let(:project_work_package) { FactoryBot.create(:work_package, type: type, project: project) }
    let(:other_project) { FactoryBot.create(:project, types: [other_type, type]) }
    let(:other_project_work_package) { FactoryBot.create(:work_package, type: other_type, project: other_project) }

    it 'returns the type used by a work package of the project' do
      project_work_package
      other_project_work_package

      expect(project.types_used_by_work_packages).to match_array [project_work_package.type]
    end
  end
end
