

require 'spec_helper'

describe ::BaseServices::BaseCallable, type: :model do
  let(:test_service) do
    Class.new(::BaseServices::BaseCallable) do
      def perform(*)
        state.test = 'foo'
        ServiceResult.new(success: true, result: 'something')
      end

      def rollback
        state.test = 'rolled back!'
      end
    end
  end

  let(:test_service2) do
    Class.new(::BaseServices::BaseCallable) do
      def perform(*)
        state.test2 = 'foo'
        ServiceResult.new(success: true, result: 'something')
      end

      def rollback
        state.test = 'Roll back other value'
        state.test2 = nil
      end
    end
  end

  let(:instance) { test_service.new }
  subject { instance.call }

  describe 'state' do
    let(:result_state) { subject.state }

    it 'is returned from the call', :aggregate_failures do
      expect(result_state).to be_kind_of(::Shared::ServiceState)
      expect(result_state.test).to eq 'foo'
      expect(subject).to be_kind_of ::ServiceResult

      expect(result_state.service_chain.count).to eq(1)
      expect(result_state.service_chain).to include(test_service)

      # Roll back
      expect(instance).to receive(:rollback).once.and_call_original
      result_state.rollback!
      # Second call does not go through
      result_state.rollback!

      expect(result_state.test).to eq 'rolled back!'
    end

    describe 'with state already passed into the service' do
      let(:instance) { test_service.new.with_state(bar: 'some value') }

      it 'keeps that value', :aggregate_failures do
        expect(result_state).to be_kind_of(::Shared::ServiceState)
        expect(result_state.test).to eq 'foo'
        expect(result_state.bar).to eq 'some value'
      end
    end
  end

  describe 'rolling back two services' do
    it 'rolls back in that order' do
      # Execute first service
      result = test_service.new.call
      state = result.state

      # Execute second service
      test_service2
        .new
        .with_state(state)
        .call

      expect(state.service_chain.map(&:class)).to eq [test_service, test_service2]
      state.rollback!
      expect(state.test2).to eq nil
      expect(state.test).to eq 'rolled back!'
    end
  end
end
