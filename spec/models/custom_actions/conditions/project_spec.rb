
require 'spec_helper'
require_relative '../shared_expectations'

describe CustomActions::Conditions::Project, type: :model do
  it_behaves_like 'associated custom condition' do
    let(:key) { :project }

    describe '#allowed_values' do
      it 'is the list of all projects' do
        projects = [FactoryBot.build_stubbed(:project),
                    FactoryBot.build_stubbed(:project)]
        allow(Project)
          .to receive_message_chain(:active, :select, :order)
          .and_return(projects)

        expect(instance.allowed_values)
          .to eql([{ value: projects.first.id, label: projects.first.name },
                   { value: projects.last.id, label: projects.last.name }])
      end
    end

    describe '#fulfilled_by?' do
      let(:work_package) { double('work_package', project_id: 1) }
      let(:user) { double('not relevant') }

      it 'is true if values are empty' do
        instance.values = []

        expect(instance.fulfilled_by?(work_package, user))
          .to be_truthy
      end

      it "is true if values include work package's project_id" do
        instance.values = [1]

        expect(instance.fulfilled_by?(work_package, user))
          .to be_truthy
      end

      it "is false if values do not include work package's project_id" do
        instance.values = [5]

        expect(instance.fulfilled_by?(work_package, user))
          .to be_falsey
      end
    end
  end
end
