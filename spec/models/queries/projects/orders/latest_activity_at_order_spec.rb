#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Projects::Orders::LatestActivityAtOrder, type: :model do
  let(:instance) do
    described_class.new('').tap do |i|
      i.direction = direction
    end
  end
  let(:direction) { :asc }

  describe '#scope' do
    context 'with a valid direction' do
      it 'orders by the disk space' do
        expect(instance.scope.to_sql)
          .to eql(Project.order(Arel.sql("activity.latest_activity_at").asc).to_sql)
      end
    end

    context 'with an invalid direction' do
      let(:direction) { 'bogus' }

      it 'raises an error' do
        expect { instance.scope }
          .to raise_error(ArgumentError)
      end
    end
  end
end
