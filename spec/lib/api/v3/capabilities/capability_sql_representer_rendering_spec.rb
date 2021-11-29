

require 'spec_helper'

describe ::API::V3::Capabilities::CapabilitySqlRepresenter, 'rendering' do
  include ::API::V3::Utilities::PathHelper

  let(:scope) do
    Capability
      .where(principal_id: principal.id,
             context_id: context&.id)
      .order(:action)
      .limit(1)
  end
  let(:principal) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: %i[view_members])
  end
  let(:project) do
    FactoryBot.create(:project)
  end
  let(:context) do
    project
  end

  current_user do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: [])
  end

  subject(:json) do
    ::API::V3::Utilities::SqlRepresenterWalker
      .new(scope,
           embed: {},
           select: { 'id' => {}, '_type' => {}, 'self' => {}, 'action' => {}, 'context' => {}, 'principal' => {} },
           current_user: current_user)
      .walk(API::V3::Capabilities::CapabilitySqlRepresenter)
      .to_json
  end

  context 'with a project and user' do
    it 'renders as expected' do
      expect(json)
        .to be_json_eql({
          "id": "memberships/read/p#{context.id}-#{principal.id}",
          "_type": "Capability",
          "_links": {
            "context": {
              "href": api_v3_paths.project(project.id),
              "title": project.name
            },
            "principal": {
              "href": api_v3_paths.user(principal.id),
              "title": principal.name
            },
            "action": {
              "href": api_v3_paths.action("memberships/read")
            },
            "self": {
               "href": api_v3_paths.capability("memberships/read/p#{context.id}-#{principal.id}")
            }
          }
        }.to_json)
    end
  end

  context 'with a project and group' do
    let(:principal) do
      FactoryBot.create(:group,
                        member_in_project: project,
                        member_with_permissions: %i[view_members])
    end

    it 'renders as expected' do
      expect(json)
        .to be_json_eql({
          "id": "memberships/read/p#{context.id}-#{principal.id}",
          "_type": "Capability",
          "_links": {
            "context": {
              "href": api_v3_paths.project(project.id),
              "title": project.name
            },
            "principal": {
              "href": api_v3_paths.group(principal.id),
              "title": principal.name
            },
            "action": {
              "href": api_v3_paths.action("memberships/read")
            },
            "self": {
              "href": api_v3_paths.capability("memberships/read/p#{context.id}-#{principal.id}")
            }
          }
        }.to_json)
    end
  end

  context 'with a global permission' do
    let(:principal) do
      FactoryBot.create(:user,
                        global_permission: %i[manage_user],
                        member_in_project: project,
                        member_with_permissions: [])
    end
    let(:context) { nil }

    it 'renders as expected' do
      expect(json)
        .to be_json_eql({
          "id": "users/create/g-#{principal.id}",
          "_type": "Capability",
          "_links": {
            "context": {
              "href": api_v3_paths.capabilities_contexts_global,
              "title": 'Global'
            },
            "principal": {
              "href": api_v3_paths.user(principal.id),
              "title": principal.name
            },
            "action": {
              "href": api_v3_paths.action("users/create")
            },
            "self": {
              "href": api_v3_paths.capability("users/create/g-#{principal.id}")
            }
          }
        }.to_json)
    end
  end
end
