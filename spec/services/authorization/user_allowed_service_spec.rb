

require 'spec_helper'

describe Authorization::UserAllowedService do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:instance) { described_class.new(user) }
  let(:action) { :an_action }
  let(:action_hash) { { controller: '/controller', action: 'action' } }
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:other_project) { FactoryBot.build_stubbed(:project) }
  let(:role) { FactoryBot.build_stubbed(:role) }
  let(:user_roles_in_project) do
    array = [role]
    allow(array)
      .to receive(:eager_load)
      .and_return(array)

    array
  end
  let(:role_grants_action) { true }
  let(:project_allows_to) { true }

  describe '#initialize' do
    it 'has the user' do
      expect(instance.user).to eql user
    end
  end

  shared_examples_for 'successful run' do
    it 'is successful' do
      expect(instance.call(action, context)).to be_success
    end
  end

  shared_examples_for 'allowed to checked' do
    before do
      Array(context).each do |project|
        project.active = true

        allow(project)
          .to receive(:allows_to?)
          .with(action)
          .and_return(project_allows_to)

        allow(Authorization)
          .to receive(:roles)
          .with(user, project)
          .and_return(user_roles_in_project)
      end

      allow(role)
        .to receive(:allowed_to?)
        .with(action)
        .and_return(role_grants_action)
    end

    context 'with the user having a granting role' do
      it_behaves_like 'successful run' do
        it 'is true' do
          expect(instance.call(action, context).result).to be_truthy
        end

        it 'does not call the db twice for a project' do
          Array(context).each do |project|
            expect(Authorization)
              .to receive(:roles)
              .once
              .with(user, project)
              .and_return(user_roles_in_project)
          end

          instance.call(action, context)
          instance.call(action, context)
        end
      end

      context 'but the user not being active' do
        before do
          user.lock
        end

        it 'returns false', :aggregate_failures do
          expect(instance.call(action, nil, global: true)).to be_success
          expect(instance.call(action, nil, global: true).result).not_to be_truthy
        end
      end
    end

    context 'with the user having a nongranting role' do
      let(:role_grants_action) { false }

      it_behaves_like 'successful run' do
        it 'is false' do
          expect(instance.call(action, context).result).to be_falsey
        end
      end
    end

    context 'with the user being admin
             with the user not having a granting role' do
      let(:user_roles_in_project) { [] }

      before do
        user.admin = true
      end

      it_behaves_like 'successful run' do
        it 'is true' do
          expect(instance.call(action, context).result).to be_truthy
        end
      end
    end

    context 'with the project not being active' do
      before do
        Array(context).each do |project|
          project.active = false
        end
      end

      it_behaves_like 'successful run' do
        it 'is false' do
          expect(instance.call(action, context).result).to be_falsey
        end

        it 'is false even if the user is admin' do
          user.admin = true

          expect(instance.call(action, context).result).to be_falsey
        end
      end
    end

    context 'with the project not having the action enabled' do
      let(:project_allows_to) { false }

      it_behaves_like 'successful run' do
        it 'is false' do
          expect(instance.call(action, context).result).to be_falsey
        end

        it 'is false even if the user is admin' do
          user.admin = true

          expect(instance.call(action, context).result).to be_falsey
        end
      end
    end

    context 'with having precached the results' do
      before do
        auth_cache = double('auth_cache')

        allow(Users::ProjectAuthorizationCache)
          .to receive(:new)
          .and_return(auth_cache)

        allow(auth_cache)
          .to receive(:cache)
          .with(action)

        allow(auth_cache)
          .to receive(:cached?)
          .with(action)
          .and_return(true)

        Array(context).each do |project|
          allow(auth_cache)
            .to receive(:allowed?)
            .with(action, project)
            .and_return(true)
        end

        instance.preload_projects_allowed_to(action)
      end

      it_behaves_like 'successful run' do
        it 'is true' do
          expect(instance.call(action, context).result).to be_truthy
        end

        it 'does not call the db' do
          expect(Authorization)
            .to_not receive(:roles)

          instance.call(action, context)
        end
      end
    end
  end

  describe '#call' do
    context 'for a project' do
      let(:context) { project }

      it_behaves_like 'allowed to checked'
    end

    context 'for an array of projects' do
      let(:context) { [project, other_project] }

      it_behaves_like 'allowed to checked'

      context 'with the array being empty' do
        it_behaves_like 'successful run' do
          it 'is false' do
            expect(instance.call(action, []).result).to be_falsey
          end
        end
      end

      context 'with one project not allowing an action' do
        before do
          allow(project)
            .to receive(:allows_to?)
            .with(action)
            .and_return(false)
        end

        it_behaves_like 'successful run' do
          it 'is false' do
            expect(instance.call(action, [project, other_project]).result).to be_falsey
          end
        end
      end
    end

    context 'for a relation of projects' do
      let(:context) { double('relation', class: ActiveRecord::Relation, to_a: [project]) }

      it_behaves_like 'allowed to checked'
    end

    context 'for anything else' do
      let(:context) { nil }

      it 'is false' do
        expect(instance.call(action, context).result).to be_falsey
      end

      it 'is unsuccessful' do
        expect(instance.call(action, context)).to_not be_success
      end
    end

    context 'for a global check' do
      context 'with the user being admin' do
        before do
          user.admin = true
        end

        it 'is true' do
          expect(instance.call(action, nil, global: true).result).to be_truthy
        end

        it 'is successful' do
          expect(instance.call(action, nil, global: true)).to be_success
        end
      end

      context 'with the user having a granting role' do
        before do
          allow(Authorization)
            .to receive(:roles)
            .with(user, nil)
            .and_return(user_roles_in_project)

          allow(role)
            .to receive(:allowed_to?)
            .with(action)
            .and_return(true)
        end

        context 'but the user not being active' do
          before do
            user.lock
          end

          it 'is unsuccessful', :aggregate_failures do
            expect(instance.call(action, nil, global: true)).to be_success
            expect(instance.call(action, nil, global: true).result).not_to be_truthy
          end
        end

        it 'is successful', :aggregate_failures do
          expect(instance.call(action, nil, global: true).result).to be_truthy
          expect(instance.call(action, nil, global: true)).to be_success
        end
      end

      context 'with the user not having a granting role' do
        before do
          allow(Authorization)
            .to receive(:roles)
            .with(user, nil)
            .and_return(user_roles_in_project)

          allow(role)
            .to receive(:allowed_to?)
            .with(action)
            .and_return(false)
        end

        it 'is false' do
          expect(instance.call(action, nil, global: true).result).to be_falsey
        end

        it 'is successful' do
          expect(instance.call(action, nil, global: true)).to be_success
        end
      end
    end
  end
end
