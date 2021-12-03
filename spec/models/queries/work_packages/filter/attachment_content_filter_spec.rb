

require 'spec_helper'

describe Queries::WorkPackages::Filter::AttachmentContentFilter, type: :model do
  if ProyeksiApp::Database.allows_tsv?
    before do
      allow(EnterpriseToken).to receive(:allows_to?).and_return(false)
      allow(EnterpriseToken).to receive(:allows_to?).with(:attachment_filters).and_return(true)
    end

    context 'WP with attachment' do
      let(:context) { nil }
      let(:value) { 'ipsum' }
      let(:operator) { '~' }
      let(:instance) do
        described_class.create!(name: :search, context: context, operator: operator, values: [value])
      end

      let(:work_package) { FactoryBot.create(:work_package) }
      let(:text) { 'lorem ipsum' }
      let(:attachment) { FactoryBot.create(:attachment, container: work_package) }

      before do
        allow_any_instance_of(Plaintext::Resolver).to receive(:text).and_return(text)
        allow(attachment).to receive(:readable?).and_return(true)
        attachment.reload
      end

      it 'finds WP through attachment content' do
        perform_enqueued_jobs

        expect(WorkPackage.joins(instance.joins).where(instance.where))
          .to match_array [work_package]
      end
    end

    it_behaves_like 'basic query filter' do
      let(:type) { :text }
      let(:class_key) { :attachment_content }

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
