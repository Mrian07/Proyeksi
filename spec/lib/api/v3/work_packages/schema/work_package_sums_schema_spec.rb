

require 'spec_helper'

describe ::API::V3::WorkPackages::Schema::WorkPackageSumsSchema do
  let(:current_user) { double('current user') }

  subject { described_class.new }

  describe '#available_custom_fields' do
    let(:cf1) { double }
    let(:cf2) { double }
    let(:cf3) { double }

    it 'returns all custom fields listed as summable' do
      allow(WorkPackageCustomField)
        .to receive_message_chain(:summable) { [cf1, cf2, cf3] }

      expect(subject.available_custom_fields).to match_array [cf1, cf2, cf3]
    end
  end
end
