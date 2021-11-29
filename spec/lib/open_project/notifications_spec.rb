

require 'spec_helper'

describe OpenProject::Notifications do
  let(:probe) { lambda { |*_args| } }
  let(:payload) { { 'test' => 'payload' } }

  describe '.send' do
    before do
      # We can't clean this up, so we need to use a unique name
      OpenProject::Notifications.subscribe('notifications_spec_send', &probe)

      expect(probe).to receive(:call) do |payload|
        # Don't check for object identity for the payload as it might be
        # marshalled and unmarshalled before being delivered in the future.
        expect(payload).to eql(payload)
      end
    end

    it 'should deliver a notification' do
      OpenProject::Notifications.send('notifications_spec_send', payload)
    end
  end

  describe '.subscribe' do
    it 'throws an error when no callback is given' do
      expect do
        OpenProject::Notifications.subscribe('notifications_spec_send')
      end.to raise_error ArgumentError, /provide a block as a callback/
    end

    describe 'clear_subscriptions:' do
      let(:key) { 'test_clear_subs' }
      let(:as) { [] }
      let(:bs) { [] }

      def example_with(clear:)
        OpenProject::Notifications.subscribe(key) do |out|
          as << out
        end
        OpenProject::Notifications.send(key, 1)

        OpenProject::Notifications.subscribe(key, clear_subscriptions: clear) do |out|
          bs << out
        end
        OpenProject::Notifications.send(key, 2)
      end

      context 'true' do
        before do
          example_with clear: true
        end

        it 'clears previous subscriptions' do
          expect(as).to eq [1]
          expect(bs).to eq [2]
        end
      end

      context 'false' do
        before do
          example_with clear: false
        end

        it 'notifies both subscriptions' do
          expect(as).to eq [1, 2]
          expect(bs).to eq [2]
        end
      end
    end
  end
end
