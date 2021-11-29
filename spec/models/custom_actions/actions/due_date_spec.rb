

require 'spec_helper'
require_relative '../shared_expectations'

describe CustomActions::Actions::DueDate, type: :model do
  let(:key) { :due_date }
  let(:type) { :date_property }
  let(:value) { Date.today }

  it_behaves_like 'base custom action' do
    describe '#multi_value?' do
      it 'is false' do
        expect(instance)
          .not_to be_multi_value
      end
    end

    it_behaves_like 'date custom action validations'
    it_behaves_like 'date values transformation'
    it_behaves_like 'date custom action apply'
  end
end
