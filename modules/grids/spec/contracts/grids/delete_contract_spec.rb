#-- encoding: UTF-8



require 'spec_helper'

describe Grids::DeleteContract do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:grid) do
    FactoryBot.build_stubbed(:grid)
  end

  let(:instance) { described_class.new(grid, user) }

  before do
    allow(Grids::Configuration)
      .to receive(:writable?)
            .and_return(writable)

    allow(grid).to receive(:user_deletable?).and_return(user_deletable)
  end

  context 'when writable' do
    let(:writable) { true }
    let(:user_deletable) { true }

    it 'deletes the grid even if no valid widgets' do
      expect(instance.validate).to be_truthy
    end
  end

  context 'when not writable' do
    let(:writable) { false }
    let(:user_deletable) { true }

    it 'deletes the grid even if not valid' do
      expect(instance.validate).to be_falsey
    end
  end

  context 'when not deletable' do
    let(:writable) { true }
    let(:user_deletable) { false }

    it 'deletes the grid even if not valid' do
      expect(instance.validate).to be_falsey
    end
  end
end
