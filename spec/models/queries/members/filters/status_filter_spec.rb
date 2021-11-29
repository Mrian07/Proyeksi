#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Members::Filters::StatusFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :status }
    let(:type) { :list }

    describe '#allowed_values' do
      it 'is a list of the possible values' do
        expected = Principal.statuses.keys.map do |key|
          [I18n.t(:"status_#{key}"), key]
        end

        expect(instance.allowed_values).to match_array(expected)
      end
    end
  end
end
