#-- encoding: UTF-8



require 'spec_helper'
require 'services/base_services/behaves_like_update_service'

describe Projects::UpdateService, type: :model do
  it_behaves_like 'BaseServices update service' do
    let!(:model_instance) do
      FactoryBot.build_stubbed(:project, status: project_status).tap do |_p|
        project_status.clear_changes_information
      end
    end
    let(:project_status) { FactoryBot.build_stubbed(:project_status) }

    it 'sends an update notification' do
      expect(ProyeksiApp::Notifications)
        .to(receive(:send))
        .with('project_updated', project: model_instance)

      subject
    end

    context 'if the identifier is altered' do
      let(:call_attributes) { { identifier: 'Some identifier' } }

      before do
        allow(model_instance)
          .to(receive(:changes))
          .and_return('identifier' => %w(lorem ipsum))
      end

      it 'sends the notification' do
        expect(ProyeksiApp::Notifications)
          .to(receive(:send))
          .with('project_updated', project: model_instance)
        expect(ProyeksiApp::Notifications)
          .to(receive(:send))
          .with('project_renamed', project: model_instance)

        subject
      end
    end

    context 'if the parent is altered' do
      before do
        allow(model_instance)
          .to(receive(:changes))
          .and_return('parent_id' => [nil, 5])
      end

      it 'updates the versions associated with the work packages' do
        expect(WorkPackage)
          .to(receive(:update_versions_from_hierarchy_change))
          .with(model_instance)

        subject
      end
    end

    context 'if the project status is altered' do
      before do
        allow(project_status)
          .to(receive(:changed?))
          .and_return(true)
      end

      it 'persists the changes' do
        expect(project_status).to receive(:save)

        subject
      end
    end
  end
end
