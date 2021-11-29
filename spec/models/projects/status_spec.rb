

require 'spec_helper'

describe Projects::Status, type: :model do
  let(:project) { FactoryBot.create(:project) }

  let(:explanation) { 'some explanation' }
  let(:code) { :on_track }
  let(:instance) { described_class.new explanation: explanation, code: code, project: project }

  describe 'explanation' do
    it 'stores an explanation' do
      instance.save

      instance.reload

      expect(instance.explanation)
        .to eql explanation
    end
  end

  describe 'code' do
    it 'stores a code as an enum' do
      instance.save

      instance.reload

      expect(instance.on_track?)
        .to be_truthy
    end
  end

  describe 'project' do
    it 'stores a project reference' do
      instance.save

      instance.reload

      expect(instance.project)
        .to eql project
    end

    it 'requires one' do
      instance.project = nil

      expect(instance)
        .to be_invalid

      expect(instance.errors.symbols_for(:project))
        .to eql [:blank]
    end

    it 'cannot be one already having a status' do
      described_class.create! explanation: 'some other explanation', code: :off_track, project: project

      expect(instance)
        .to be_invalid

      expect(instance.errors.symbols_for(:project))
        .to eql [:taken]
    end
  end
end
