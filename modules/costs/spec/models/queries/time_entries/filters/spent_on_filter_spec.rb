

require 'spec_helper'

describe Queries::TimeEntries::Filters::SpentOnFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:type) { :date }
    let(:class_key) { :spent_on }
    let(:human_name) { ::TimeEntry.human_attribute_name :spent_on }

    describe '#available?' do
      it 'is true' do
        expect(instance).to be_available
      end
    end

    describe '#allowed_values' do
      it 'is nil' do
        expect(instance.allowed_values).to be_nil
      end
    end

    it_behaves_like 'non ar filter'
  end
end
