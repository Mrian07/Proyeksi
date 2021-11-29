

require 'spec_helper'

describe Queries::WorkPackages::Filter::RoleFilter, type: :model do
  let(:role) { FactoryBot.build_stubbed(:role) }

  it_behaves_like 'basic query filter' do
    let(:type) { :list_optional }
    let(:class_key) { :assigned_to_role }
    let(:name) { I18n.t('query_fields.assigned_to_role') }

    describe '#available?' do
      it 'is true if any givable role exists' do
        allow(Role)
          .to receive_message_chain(:givable, :exists?)
          .and_return true

        expect(instance).to be_available
      end

      it 'is false if no givable role exists' do
        allow(Group)
          .to receive_message_chain(:givable, :exists?)
          .and_return false

        expect(instance).to_not be_available
      end
    end

    describe '#allowed_values' do
      before do
        allow(Role)
          .to receive(:givable)
          .and_return [role]
      end

      it 'is an array of role values' do
        expect(instance.allowed_values)
          .to match_array [[role.name, role.id.to_s]]
      end
    end

    describe '#ar_object_filter?' do
      it 'is true' do
        expect(instance)
          .to be_ar_object_filter
      end
    end

    describe '#value_objects' do
      let(:role2) { FactoryBot.build_stubbed(:role) }

      before do
        allow(Role)
          .to receive(:givable)
          .and_return([role, role2])

        instance.values = [role.id.to_s, role2.id.to_s]
      end

      it 'returns an array of projects' do
        expect(instance.value_objects)
          .to match_array([role, role2])
      end
    end
  end
end
