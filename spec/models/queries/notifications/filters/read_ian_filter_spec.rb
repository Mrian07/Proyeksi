

require 'spec_helper'

describe Queries::Notifications::Filters::ReadIanFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:type) { :list }
    let(:class_key) { :read_ian }

    describe '#available_operators' do
      it 'supports = and !' do
        expect(instance.available_operators)
          .to eql [Queries::Operators::BooleanEqualsStrict,
                   Queries::Operators::BooleanNotEquals]
      end
    end

    it_behaves_like 'non ar filter'
  end
end
