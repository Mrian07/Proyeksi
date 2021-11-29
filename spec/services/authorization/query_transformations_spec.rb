

require 'spec_helper'

describe Authorization::QueryTransformations do
  let(:instance) { described_class.new }

  context 'registering a transformation' do
    before do
      instance.register(:on, :name) do |*args|
        args
      end
    end

    context '#for?' do
      it 'is true for the registered name' do
        expect(instance.for?(:on)).to be_truthy
      end

      it 'is false for another name' do
        expect(instance.for?(:other_name)).to be_falsey
      end
    end

    context '#for' do
      it 'returns an array of transformations for the registered name' do
        expect(instance.for(:on).length).to eql 1

        expect(instance.for(:on)[0].on).to eql :on
        expect(instance.for(:on)[0].name).to eql :name
        expect(instance.for(:on)[0].block.call(1, 2, 3)).to match_array [1, 2, 3]
      end

      it 'is nil for another name' do
        expect(instance.for(:other_name)).to be_nil
      end
    end
  end

  context 'registering two transformations depending via after' do
    before do
      instance.register(:on, :transformation1, after: [:transformation2]) do |*args|
        args
      end

      instance.register(:on, :transformation2) do |*args|
        args.join(', ')
      end
    end

    context '#for?' do
      it 'is true for the registered name' do
        expect(instance.for?(:on)).to be_truthy
      end

      it 'is false for another name' do
        expect(instance.for?(:other_name)).to be_falsey
      end
    end

    context '#for' do
      it 'returns an array of transformations for the registered name' do
        expect(instance.for(:on).length).to eql 2

        expect(instance.for(:on)[0].on).to eql :on
        expect(instance.for(:on)[0].name).to eql :transformation2
        expect(instance.for(:on)[0].block.call(1, 2, 3)).to eql '1, 2, 3'

        expect(instance.for(:on)[1].on).to eql :on
        expect(instance.for(:on)[1].name).to eql :transformation1
        expect(instance.for(:on)[1].block.call(1, 2, 3)).to match_array [1, 2, 3]
      end
    end
  end

  context 'registering two transformations depending via before' do
    before do
      instance.register(:on, :transformation1) do |*args|
        args
      end

      instance.register(:on, :transformation2, before: [:transformation1]) do |*args|
        args.join(', ')
      end
    end

    context '#for?' do
      it 'is true for the registered name' do
        expect(instance.for?(:on)).to be_truthy
      end

      it 'is false for another name' do
        expect(instance.for?(:other_name)).to be_falsey
      end
    end

    context '#for' do
      it 'returns an array of transformations for the registered name' do
        expect(instance.for(:on).length).to eql 2

        expect(instance.for(:on)[0].on).to eql :on
        expect(instance.for(:on)[0].name).to eql :transformation2
        expect(instance.for(:on)[0].block.call(1, 2, 3)).to eql '1, 2, 3'

        expect(instance.for(:on)[1].on).to eql :on
        expect(instance.for(:on)[1].name).to eql :transformation1
        expect(instance.for(:on)[1].block.call(1, 2, 3)).to match_array [1, 2, 3]
      end
    end
  end

  context 'registering two mutually dependent transformations' do
    it 'fails' do
      instance.register(:on, :transformation1, before: [:transformation2]) do |*args|
        args
      end

      expected_order = %i[transformation1 transformation2]

      expect do
        instance.register(:on, :transformation2, before: [:transformation1]) do |*args|
          args.join(', ')
        end
      end.to raise_error "Cannot sort #{expected_order} into the list of transformations"
    end
  end
end
