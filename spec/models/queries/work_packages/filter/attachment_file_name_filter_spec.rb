

require 'spec_helper'

describe Queries::WorkPackages::Filter::AttachmentFileNameFilter, type: :model do
  if OpenProject::Database.allows_tsv?
    before do
      allow(EnterpriseToken).to receive(:allows_to?).and_return(false)
      allow(EnterpriseToken).to receive(:allows_to?).with(:attachment_filters).and_return(true)
    end

    it_behaves_like 'basic query filter' do
      let(:type) { :text }
      let(:class_key) { :attachment_file_name }

      describe '#available?' do
        it 'is available' do
          expect(instance).to be_available
        end
      end

      describe '#allowed_values' do
        it 'is nil' do
          expect(instance.allowed_values).to be_nil
        end
      end

      describe '#valid_values!' do
        it 'is a noop' do
          instance.values = ['none', 'is', 'changed']

          instance.valid_values!

          expect(instance.values)
            .to match_array ['none', 'is', 'changed']
        end
      end

      describe '#available_operators' do
        it 'supports ~ and !~' do
          expect(instance.available_operators)
            .to eql [Queries::Operators::Contains, Queries::Operators::NotContains]
        end
      end

      it_behaves_like 'non ar filter'
    end
  end
end
