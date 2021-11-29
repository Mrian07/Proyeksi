

require 'spec_helper'

describe Grids::Widget, type: :model do
  let(:instance) { Grids::Widget.new }

  describe 'attributes' do
    it '#start_row' do
      instance.start_row = 5
      expect(instance.start_row)
        .to eql 5
    end

    it '#end_row' do
      instance.end_row = 5
      expect(instance.end_row)
        .to eql 5
    end

    it '#start_column' do
      instance.start_column = 5
      expect(instance.start_column)
        .to eql 5
    end

    it '#end_column' do
      instance.end_column = 5
      expect(instance.end_column)
        .to eql 5
    end

    it '#identifier' do
      instance.identifier = 'some_identifier'
      expect(instance.identifier)
        .to eql 'some_identifier'
    end

    it '#options' do
      value = {
        some: 'value',
        and: {
          also: 1
        }
      }

      instance.options = value
      expect(instance.options)
        .to eql value
    end

    it '#grid' do
      grid = Grids::Grid.new
      instance.grid = grid
      expect(instance.grid)
        .to eql grid
    end
  end
end
