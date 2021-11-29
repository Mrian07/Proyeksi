#-- encoding: UTF-8



require 'spec_helper'

describe ::Type, type: :model do
  let(:type) { FactoryBot.build(:type) }
  let(:type2) { FactoryBot.build(:type) }
  let(:project) { FactoryBot.build(:project, no_types: true) }

  describe '.enabled_in(project)' do
    before do
      type.projects << project
      type.save

      type2.save
    end

    it 'returns the types enabled in the provided project' do
      expect(Type.enabled_in(project)).to match_array([type])
    end
  end

  describe '.statuses' do
    let(:subject) { type.statuses }

    context 'when new' do
      let(:type) { FactoryBot.build(:type) }

      it 'returns an empty relation' do
        expect(subject).to be_empty
      end
    end

    context 'when existing but no statuses' do
      let(:type) { FactoryBot.create(:type) }

      it 'returns an empty relation' do
        expect(subject).to be_empty
      end
    end

    context 'when existing with workflow' do
      let(:role) { FactoryBot.create(:role) }
      let(:statuses) { (1..2).map { |_i| FactoryBot.create(:status) } }

      let!(:type) { FactoryBot.create(:type) }
      let!(:workflow_a) do
        FactoryBot.create(:workflow, role_id: role.id,
                                     type_id: type.id,
                                     old_status_id: statuses[0].id,
                                     new_status_id: statuses[1].id,
                                     author: false,
                                     assignee: false)
      end

      it 'returns the statuses relation' do
        expect(subject.pluck(:id)).to contain_exactly(statuses[0].id, statuses[1].id)
      end

      context 'with default status' do
        let!(:default_status) { FactoryBot.create(:default_status) }
        let(:subject) { type.statuses(include_default: true) }

        it 'returns the workflow and the default status' do
          expect(subject.pluck(:id)).to contain_exactly(default_status.id, statuses[0].id, statuses[1].id)
        end
      end
    end
  end

  describe '#copy_from_type on workflows' do
    before do
      allow(Workflow)
        .to receive(:copy)
    end

    it 'calls the .copy method on Workflow' do
      type.workflows.copy_from_type(type2)

      expect(Workflow)
        .to have_received(:copy)
        .with(type2, nil, type, nil)
    end
  end
end
