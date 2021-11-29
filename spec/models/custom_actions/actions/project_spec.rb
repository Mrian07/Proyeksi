
require 'spec_helper'
require_relative '../shared_expectations'

describe CustomActions::Actions::Project, type: :model do
  let(:key) { :project }
  let(:type) { :associated_property }
  let(:priority) { 10 }

  let(:allowed_values) do
    projects = [FactoryBot.build_stubbed(:project),
                FactoryBot.build_stubbed(:project)]
    allow(Project)
      .to receive_message_chain(:select, :order)
            .and_return(projects)

    [{ value: projects.first.id, label: projects.first.name },
     { value: projects.last.id, label: projects.last.name }]
  end

  it_behaves_like 'base custom action'
  it_behaves_like 'associated custom action' do
    describe '#allowed_values' do
      it 'is the list of all project' do
        allowed_values

        expect(instance.allowed_values)
          .to eql(allowed_values)
      end
    end
  end
end
