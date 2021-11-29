

require 'spec_helper'

describe Queries::WorkPackages::Filter::ProjectFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:type) { :list }
    let(:class_key) { :project_id }

    describe '#available?' do
      context 'within a project' do
        it 'is false' do
          expect(instance).to_not be_available
        end
      end

      context 'outside of a project' do
        let(:project) { nil }

        it 'is true if the user can see project' do
          allow(Project)
            .to receive_message_chain(:visible, :active, :exists?)
            .and_return(true)

          expect(instance).to be_available
        end

        it 'is true if the user can not see project' do
          allow(Project)
            .to receive_message_chain(:visible, :active, :exists?)
            .and_return(false)

          expect(instance).to_not be_available
        end
      end
    end

    describe '#allowed_values' do
      let(:project) { nil }

      it 'is an array of group values' do
        parent = FactoryBot.build_stubbed(:project, id: 1)
        child = FactoryBot.build_stubbed(:project, parent: parent, id: 2)

        visible_projects = [parent, child]

        allow(Project)
          .to receive_message_chain(:visible, :active)
          .and_return(visible_projects)

        allow(Project)
          .to receive(:project_tree)
          .with(visible_projects)
          .and_yield(parent, 0)
          .and_yield(child, 1)

        expect(instance.allowed_values)
          .to match_array [[parent.name, parent.id.to_s],
                           ["-- #{child.name}", child.id.to_s]]
      end
    end

    describe '#ar_object_filter?' do
      it 'is true' do
        expect(instance)
          .to be_ar_object_filter
      end
    end

    describe '#value_objects' do
      let(:project) { FactoryBot.build_stubbed(:project) }
      let(:project2) { FactoryBot.build_stubbed(:project) }

      before do
        allow(Project)
          .to receive_message_chain(:visible, :active)
          .and_return([project, project2])

        instance.values = [project.id.to_s]
      end

      it 'returns an array of projects' do
        expect(instance.value_objects)
          .to match_array([project])
      end
    end
  end
end
