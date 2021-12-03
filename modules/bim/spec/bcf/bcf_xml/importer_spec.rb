

require 'spec_helper'

describe ::ProyeksiApp::Bim::BcfXml::Importer do
  let(:filename) { 'MaximumInformation.bcf' }
  let(:file) do
    Rack::Test::UploadedFile.new(
      File.join(Rails.root, "modules/bim/spec/fixtures/files/#{filename}"),
      'application/octet-stream'
    )
  end
  let(:type) { FactoryBot.create :type, name: 'Issue', is_standard: true, is_default: true }
  let(:project) do
    FactoryBot.create(:project,
                      identifier: 'bim_project',
                      enabled_module_names: %w[bim work_package_tracking],
                      types: [type])
  end
  let(:member_role) do
    FactoryBot.create(:role,
                      permissions: %i[view_linked_issues view_work_packages])
  end
  let(:manage_bcf_role) do
    FactoryBot.create(
      :role,
      permissions: %i[manage_bcf view_linked_issues view_work_packages edit_work_packages add_work_packages]
    )
  end
  let(:bcf_manager) { FactoryBot.create(:user) }
  let(:workflow) do
    FactoryBot.create(:workflow_with_default_status,
                      role: manage_bcf_role,
                      type: type)
  end
  let(:priority) { FactoryBot.create :default_priority }
  let(:bcf_manager_member) do
    FactoryBot.create(:member,
                      project: project,
                      user: bcf_manager,
                      roles: [manage_bcf_role, member_role])
  end

  subject { described_class.new file, project, current_user: bcf_manager }

  before do
    workflow
    priority
    bcf_manager_member
  end

  describe '#to_listing' do
    context 'without sufficient permissions' do
      context 'no add_work_packages permission' do
        pending 'test that importing user has add_work_packages permission'
      end

      context 'no manage_members permission' do
        pending 'test that non members should not be able to prepare an import'
      end
    end
  end

  describe '#import!' do
    it 'imports successfully' do
      expect(subject.import!).to be_present
    end

    it 'creates 2 work packages' do
      subject.import!

      expect(::Bim::Bcf::Issue.count).to be_eql 2
      expect(WorkPackage.count).to be_eql 2
    end
  end

  context 'with a viewpoint and snapshot' do
    let(:filename) { 'issue-with-viewpoint.bcf' }

    it 'imports that viewpoint successfully' do
      expect(subject.import!).to be_present

      expect(::Bim::Bcf::Issue.count).to eq 1
      issue = ::Bim::Bcf::Issue.last
      expect(issue.viewpoints.count).to eq 1

      viewpoint = issue.viewpoints.first
      expect(viewpoint.attachments.count).to eq 1
      expect(viewpoint.snapshot).to be_present
    end
  end
end
