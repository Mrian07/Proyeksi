#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Members::Filters::BlockedFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :blocked }
    let(:type) { :list }

    describe '#allowed_values' do
      it 'is a list of the possible values' do
        expected = [[I18n.t(:status_blocked), :blocked]]

        expect(instance.allowed_values).to match_array(expected)
      end
    end
  end
end
