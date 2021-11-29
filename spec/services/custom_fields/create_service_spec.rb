#-- encoding: UTF-8



require 'spec_helper'
require 'services/base_services/behaves_like_create_service'

describe CustomFields::CreateService, type: :model do
  it_behaves_like 'BaseServices create service' do
    context 'when creating a project cf' do
      let(:model_instance) { FactoryBot.build_stubbed :project_custom_field }

      it 'modifies the settings on successful call' do
        subject
        expect(Setting.enabled_projects_columns).to include "cf_#{model_instance.id}"
      end
    end
  end
end
