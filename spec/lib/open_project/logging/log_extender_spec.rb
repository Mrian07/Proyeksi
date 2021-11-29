

require 'spec_helper'

describe OpenProject::Logging, 'Log extenders' do
  subject { described_class.extend_payload!(payload, input_context) }

  let(:payload) do
    { method: 'GET', action: 'something', controller: 'SomeController' }
  end

  let(:input_context) do
    {}
  end

  context 'with an extender returning keys' do
    let(:return_value) do
      { some_hash: 123 }
    end

    let(:extender) do
      ->(_context) do
        return_value
      end
    end

    before do
      described_class.add_payload_extender(&extender)
    end

    after do
      described_class.instance_variable_set('@payload_extenders', nil)
    end

    it 'calls that extender as well as the default one' do
      allow(extender).to receive(:call).and_call_original

      expect(subject.keys).to contain_exactly :method, :action, :controller, :some_hash, :user
      expect(subject[:some_hash]).to eq 123
    end
  end

  context 'with an extender raising an error' do
    let(:return_value) do
      { some_hash: 123 }
    end

    let(:extender) do
      ->(_context) do
        raise "This is not good."
      end
    end

    before do
      described_class.add_payload_extender(&extender)
    end

    after do
      described_class.instance_variable_set('@payload_extenders', nil)
    end

    it 'does not break the returned payload' do
      allow(extender).to receive(:call).and_call_original

      expect(subject.keys).to contain_exactly :method, :action, :controller, :user
      expect(subject[:some_hash]).to eq nil
    end
  end
end
