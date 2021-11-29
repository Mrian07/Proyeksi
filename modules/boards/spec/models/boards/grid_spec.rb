

require 'spec_helper'

describe Boards::Grid, type: :model do
  let(:instance) { described_class.new }
  let(:project) { FactoryBot.build_stubbed(:project) }

  context 'attributes' do
    it '#project' do
      instance.project = project
      expect(instance.project)
        .to eql project
    end

    it '#name' do
      instance.name = nil

      expect(instance).not_to be_valid
      expect(instance.errors[:name]).to be_present

      instance.name = 'foo'
      expect(instance).to be_valid
    end
  end
end
