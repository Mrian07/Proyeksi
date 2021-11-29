

require 'spec_helper'

describe UpdateProjectsTypesService do
  let(:project) { double(Project, types_used_by_work_packages: []) }
  let(:type) { double(Type, id: 456, name: 'A type') }
  let(:standard_type) { double('StandardType', id: 123) }
  let(:instance) { described_class.new(project) }

  before do
    allow(Type).to receive(:standard_type).and_return standard_type
  end

  describe '.call' do
    context 'with ids provided' do
      let(:ids) { [1, 2, 3] }

      it 'returns true and updates the ids' do
        expect(project).to receive(:type_ids=).with(ids)

        expect(instance.call(ids)).to be_truthy
      end
    end

    context 'with no id passed' do
      let(:ids) { [] }

      it 'adds the id of the default type and returns true' do
        expect(project).to receive(:type_ids=).with([standard_type.id])

        expect(instance.call(ids)).to be_truthy
      end
    end

    context 'with nil passed' do
      let(:ids) { nil }

      it 'adds the id of the default type and returns true' do
        expect(project).to receive(:type_ids=).with([standard_type.id])

        expect(instance.call(ids)).to be_truthy
      end
    end

    context 'the id of a type in use is not provided' do
      before do
        allow(project).to receive(:types_used_by_work_packages).and_return([type])
      end

      it 'returns false and sets an error message' do
        ids = [1]

        errors = double('Errors')
        expect(project).to receive(:errors).and_return(errors)
        expect(errors).to receive(:add).with(:type, :in_use_by_work_packages, types: type.name)

        expect(project).to_not receive(:type_ids=)

        expect(instance.call(ids)).to be_falsey
      end
    end
  end
end
