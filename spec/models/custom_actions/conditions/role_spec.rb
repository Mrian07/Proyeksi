
require 'spec_helper'
require_relative '../shared_expectations'

describe CustomActions::Conditions::Role, type: :model do
  it_behaves_like 'associated custom condition' do
    let(:key) { :role }

    describe '#allowed_values' do
      it 'is the list of all roles' do
        roles = [FactoryBot.build_stubbed(:role),
                 FactoryBot.build_stubbed(:role)]

        allow(Role)
          .to receive_message_chain(:givable, :select)
          .and_return(roles)

        expect(instance.allowed_values)
          .to eql([{ value: roles.first.id, label: roles.first.name },
                   { value: roles.last.id, label: roles.last.name }])
      end
    end

    describe '#fulfilled_by?' do
      let(:project) { double('project', id: 1) }
      let(:work_package) { double('work_package', project: project, project_id: 1) }
      let(:user) do
        double('user', id: 3).tap do |user|
          allow(user)
            .to receive(:roles_for_project)
            .with(project)
            .and_return(roles)
        end
      end
      let(:role1) { double('role', id: 1) }
      let(:role2) { double('role', id: 2) }
      let(:roles) { [role1, role2] }

      it 'is true if values are empty' do
        instance.values = []

        expect(instance.fulfilled_by?(work_package, user))
          .to be_truthy
      end

      it "is true if values the id of roles the user has in the work package's project" do
        instance.values = [1]

        expect(instance.fulfilled_by?(work_package, user))
          .to be_truthy
      end

      it "is false if values do not include work package's status_id" do
        instance.values = [5]

        expect(instance.fulfilled_by?(work_package, user))
          .to be_falsey
      end
    end
  end
end
