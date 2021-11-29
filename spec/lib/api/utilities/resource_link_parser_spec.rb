

require 'spec_helper'

describe ::API::Utilities::ResourceLinkParser do
  subject { described_class }

  describe '#parse' do
    shared_examples_for 'accepts resource link' do
      it 'parses the version' do
        expect(result[:version]).to eql(version)
      end

      it 'parses the namespace' do
        expect(result[:namespace]).to eql(namespace)
      end

      it 'parses the id' do
        expect(result[:id]).to eql(id)
      end
    end

    shared_examples_for 'rejects resource link' do
      it 'is nil' do
        expect(result).to be_nil
      end
    end

    describe 'generic resource links' do
      describe 'accepts a simple resource' do
        it_behaves_like 'accepts resource link' do
          let(:result) { subject.parse '/api/v3/statuses/12' }
          let(:version) { '3' }
          let(:namespace) { 'statuses' }
          let(:id) { '12' }
        end
      end

      describe 'accepts a nested namespace resource' do
        it_behaves_like 'accepts resource link' do
          let(:result) { subject.parse '/api/v3/time_entries/activities/12' }
          let(:version) { '3' }
          let(:namespace) { 'time_entries/activities' }
          let(:id) { '12' }
        end
      end

      describe 'rejects resources with empty id segment' do
        it_behaves_like 'rejects resource link' do
          let(:result) { subject.parse '/api/v3/statuses/' }
        end
      end

      describe 'rejects resource with missing id segment' do
        it_behaves_like 'rejects resource link' do
          let(:result) { subject.parse '/api/v3/statuses' }
        end
      end

      describe 'rejects the api root' do
        it_behaves_like 'rejects resource link' do
          let(:result) { subject.parse '/api/v3/' }
        end
      end

      describe 'rejects nested resources' do
        it_behaves_like 'rejects resource link' do
          let(:result) { subject.parse '/api/v3/statuses/imaginary/' }
        end
      end
    end
  end

  describe '#parse_id' do
    it 'parses the id' do
      expect(subject.parse_id('/api/v3/statuses/14', property: 'foo')).to eql('14')
    end

    it 'parses the id with nested namespace' do
      expect(subject.parse_id('/api/v3/statuses/nested/14', property: 'foo')).to eql('14')
    end

    it 'parses a non decimal id with nested namespace' do
      expect(subject.parse_id('/api/v3/statuses/nested/=', property: 'foo')).to eql('=')
    end

    it 'accepts on matching version' do
      expect do
        subject.parse_id('/api/v3/statuses/14', property: 'foo', expected_version: '3')
      end.not_to raise_error
    end

    it 'accepts on matching version as integer' do
      expect do
        subject.parse_id('/api/v3/statuses/14', property: 'foo', expected_version: 3)
      end.not_to raise_error
    end

    it 'accepts on matching namespace' do
      expect do
        subject.parse_id('/api/v3/statuses/14', property: 'foo', expected_namespace: 'statuses')
      end.not_to raise_error
    end

    it 'accepts on matching namespace as symbol' do
      expect do
        subject.parse_id('/api/v3/statuses/14', property: 'foo', expected_namespace: :statuses)
      end.not_to raise_error
    end

    it 'raises on version mismatch' do
      expect do
        subject.parse_id('/api/v4/statuses/14', property: 'foo', expected_version: '3')
      end.to raise_error(::API::Errors::InvalidResourceLink)
    end

    it 'raises on namespace mismatch' do
      expect do
        subject.parse_id('/api/v3/types/14', property: 'foo', expected_namespace: 'statuses')
      end.to raise_error(::API::Errors::InvalidResourceLink)
    end

    it 'contains the property name in exception messages' do
      property_name = 'My Property Name'
      expect do
        subject.parse_id('/api/v4/statuses/14', property: property_name, expected_version: '3')
      end.to raise_error(Regexp.compile(property_name))
    end
  end
end
