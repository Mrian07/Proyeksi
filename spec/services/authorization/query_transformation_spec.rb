

require 'spec_helper'

describe Authorization::QueryTransformation do
  let(:on) { 'on' }
  let(:name) { 'name' }
  let(:after) { 'after' }
  let(:before) { 'before' }
  let(:block) { ->(*args) { args } }

  let(:instance) do
    described_class.new on,
                        name,
                        after,
                        before,
                        block
  end

  context 'initialSetup' do
    it 'sets on' do
      expect(instance.on).to eql on
    end

    it 'sets name' do
      expect(instance.name).to eql name
    end

    it 'sets after' do
      expect(instance.after).to eql after
    end

    it 'sets before' do
      expect(instance.before).to eql before
    end

    it 'sets block' do
      expect(instance.block).to eql block
    end
  end

  context 'apply' do
    it 'calls the block' do
      expect(instance.apply(1, 2, 3)).to match_array [1, 2, 3]
    end
  end
end
