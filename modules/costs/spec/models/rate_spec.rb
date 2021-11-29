

require File.dirname(__FILE__) + '/../spec_helper'

describe Rate, type: :model do
  let(:rate) { FactoryBot.build(:rate) }

  describe '#valid?' do
    describe 'WHEN no rate is supplied' do
      before do
        rate.rate = nil
      end

      it 'should not be valid' do
        expect(rate).not_to be_valid
        expect(rate.errors[:rate]).to eq([I18n.t('activerecord.errors.messages.not_a_number')])
      end
    end

    describe 'WHEN no number is supplied' do
      before do
        rate.rate = 'test'
      end

      it 'should not be valid' do
        expect(rate).not_to be_valid
        expect(rate.errors[:rate]).to eq([I18n.t('activerecord.errors.messages.not_a_number')])
      end
    end

    describe 'WHEN a rate is supplied' do
      before do
        rate.rate = 5.0
      end

      it { expect(rate).to be_valid }
    end

    describe 'WHEN a date is supplied' do
      before do
        rate.valid_from = Date.today
      end

      it { expect(rate).to be_valid }
    end

    describe 'WHEN a transformable string is supplied for date' do
      before do
        rate.valid_from = '2012-03-04'
      end

      it { expect(rate).to be_valid }
    end

    describe 'WHEN a nontransformable string is supplied for date' do
      before do
        rate.valid_from = '2012-02-30'
      end

      it 'should not be valid' do
        expect(rate).not_to be_valid
        expect(rate.errors[:valid_from]).to eq([I18n.t('activerecord.errors.messages.not_a_date')])
      end
    end

    describe 'WHEN no value is supplied for date' do
      before do
        rate.valid_from = nil
      end

      it 'should not be valid' do
        expect(rate).not_to be_valid
        expect(rate.errors[:valid_from]).to eq([I18n.t('activerecord.errors.messages.not_a_date')])
      end
    end
  end
end
