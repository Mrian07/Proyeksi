#-- encoding: UTF-8



require 'spec_helper'

describe Members::SetAttributesService, type: :model do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:contract_class) do
    contract = double('contract_class')

    allow(contract)
      .to receive(:new)
      .with(member, user, options: {})
      .and_return(contract_instance)

    contract
  end
  let(:contract_instance) do
    double('contract_instance', validate: contract_valid, errors: contract_errors)
  end
  let(:contract_valid) { true }
  let(:contract_errors) do
    double('contract_errors')
  end
  let(:member_valid) { true }
  let(:instance) do
    described_class.new(user: user,
                        model: member,
                        contract_class: contract_class)
  end
  let(:call_attributes) { {} }
  let(:member) do
    FactoryBot.build_stubbed(:member)
  end

  describe 'call' do
    let(:call_attributes) do
      {
        project_id: 5,
        user_id: 3
      }
    end

    before do
      allow(member)
        .to receive(:valid?)
        .and_return(member_valid)

      expect(contract_instance)
        .to receive(:validate)
        .and_return(contract_valid)
    end

    subject { instance.call(call_attributes) }

    it 'is successful' do
      expect(subject.success?).to be_truthy
    end

    it 'sets the attributes' do
      subject

      expect(member.attributes.slice(*member.changed).symbolize_keys)
        .to eql call_attributes
    end

    it 'does not persist the member' do
      expect(member)
        .not_to receive(:save)

      subject
    end

    context 'with changes to the roles do' do
      let(:first_role) { FactoryBot.build_stubbed(:role) }
      let(:second_role) { FactoryBot.build_stubbed(:role) }
      let(:third_role) { FactoryBot.build_stubbed(:role) }

      let(:call_attributes) do
        {
          role_ids: [second_role.id, third_role.id]
        }
      end

      context 'with a persisted record' do
        let(:member) do
          FactoryBot.build_stubbed(:member, roles: [first_role, second_role]).tap do |m|
            allow(m)
              .to receive(:touch)
          end
        end

        it 'adds the new role' do
          expect(subject.result.roles = [second_role, third_role])
        end
      end

      context 'with a new record' do
        let(:member) do
          Member.new
        end

        it 'adds the new role' do
          expect(subject.result.roles = [second_role, third_role])
        end

        context 'with role_ids not all being present' do
          let(:call_attributes) do
            {
              role_ids: [nil, '', second_role.id, third_role.id]
            }
          end

          it 'ignores the empty values' do
            expect(subject.result.roles = [second_role, third_role])
          end
        end
      end
    end
  end
end
