

require 'spec_helper'

describe ::API::Decorators::LinkObject do
  include ::API::V3::Utilities::PathHelper

  let(:represented) { Hashie::Mash.new }

  context 'minimal constructor call' do
    let(:representer) { described_class.new(represented, property_name: :foo) }

    before do
      represented.foo_id = 1
      allow(api_v3_paths).to receive(:foo) { |id| "/api/v3/foos/#{id}" }
    end

    describe 'generation' do
      subject { representer.to_json }

      it { is_expected.to be_json_eql('/api/v3/foos/1'.to_json).at_path('href') }
    end

    describe 'parsing' do
      subject { represented }

      let(:parsed_hash) do
        {
          'href' => '/api/v3/foos/42'
        }
      end

      it 'parses the id from the URL' do
        representer.from_hash parsed_hash
        expect(subject.foo_id).to eql('42')
      end

      context 'wrong namespace' do
        let(:parsed_hash) do
          {
            'href' => '/api/v3/bars/42'
          }
        end

        it 'throws an error' do
          expect { representer.from_hash parsed_hash }.to raise_error(
            ::API::Errors::InvalidResourceLink
          )
        end
      end
    end
  end

  context 'full constructor call' do
    let(:representer) do
      described_class.new(represented,
                          property_name: :foo,
                          path: :foo_path,
                          namespace: 'fuhs',
                          getter: :getter,
                          setter: :'setter=')
    end

    before do
      represented.getter = 1
      allow(api_v3_paths).to receive(:foo_path) { |id| "/api/v3/fuhs/#{id}" }
    end

    describe 'generation' do
      subject { representer.to_json }

      it { is_expected.to be_json_eql('/api/v3/fuhs/1'.to_json).at_path('href') }
    end

    describe 'parsing' do
      subject { represented }

      let(:parsed_hash) do
        {
          'href' => '/api/v3/fuhs/42'
        }
      end

      it 'parses the id from the URL' do
        representer.from_hash parsed_hash
        expect(subject.setter).to eql('42')
      end

      context 'wrong namespace' do
        let(:parsed_hash) do
          {
            'href' => '/api/v3/foos/42'
          }
        end

        it 'throws an error' do
          expect { representer.from_hash parsed_hash }.to raise_error(
            ::API::Errors::InvalidResourceLink
          )
        end
      end
    end
  end
end
