#-- encoding: UTF-8


require 'spec_helper'
require 'representable/json'

describe Representable do
  let(:object) { Struct.new(:title).new('test') }

  class ReverseNamingStrategy
    def call(name)
      name.reverse
    end
  end

  describe 'as_strategy with lambda' do
    class UpcaseRepresenter < Representable::Decorator
      include Representable::JSON

      self.as_strategy = ->(name) { name.upcase }

      property :title
    end

    it { expect(UpcaseRepresenter.new(object).to_json).to eql("{\"TITLE\":\"test\"}") }
  end

  describe 'as_strategy with class responding to #call?' do
    class ReverseRepresenter < Representable::Decorator
      include Representable::JSON

      self.as_strategy = ReverseNamingStrategy.new

      property :title
    end

    it { expect(ReverseRepresenter.new(object).to_json).to eql("{\"eltit\":\"test\"}") }
  end

  describe 'as_strategy with class not responding to #call?' do
    it 'raises error' do
      expect do
        class FailRepresenter < Representable::Decorator
          include Representable::JSON

          self.as_strategy = ::Object.new

          property :title
        end
      end.to raise_error(RuntimeError)
    end
  end
end
