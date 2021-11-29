#-- encoding: UTF-8



shared_examples_for 'work package contract' do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:other_user) { FactoryBot.build_stubbed(:user) }
  let(:policy) { double(WorkPackagePolicy, allowed?: true) }

  subject(:contract) { described_class.new(work_package, user) }

  let(:validated_contract) do
    contract = subject
    contract.validate
    contract
  end

  before do
    allow(WorkPackagePolicy)
      .to receive(:new)
      .and_return(policy)
  end

  let(:possible_assignees) { [] }
  let!(:assignable_assignees_scope) do
    scope = double 'assignable assignees scope'

    allow(Principal)
      .to receive(:possible_assignee)
      .with(work_package_project)
      .and_return scope

    allow(scope)
      .to receive(:exists?) do |hash|
      possible_assignees.map(&:id).include?(hash[:id])
    end

    scope
  end

  shared_examples_for 'has no error on' do |property|
    it property do
      expect(validated_contract.errors[property]).to be_empty
    end
  end

  describe 'assigned_to_id' do
    before do
      work_package.assigned_to_id = other_user.id
    end

    context 'if the assigned user is a possible assignee' do
      let(:possible_assignees) { [other_user] }

      it_behaves_like 'has no error on', :assigned_to
    end

    context 'if the assigned user is not a possible assignee' do
      it 'is not a valid assignee' do
        error = I18n.t('api_v3.errors.validation.invalid_user_assigned_to_work_package',
                       property: I18n.t('attributes.assignee'))
        expect(validated_contract.errors[:assigned_to]).to match_array [error]
      end
    end

    context 'if the project is not set' do
      let(:work_package_project) { nil }

      it_behaves_like 'has no error on', :assigned_to
    end
  end

  describe 'responsible_id' do
    before do
      work_package.responsible_id = other_user.id
    end

    context 'if the responsible user is a possible responsible' do
      let(:possible_assignees) { [other_user] }
      it_behaves_like 'has no error on', :responsible
    end

    context 'if the assigned user is not a possible responsible' do
      it 'is not a valid responsible' do
        error = I18n.t('api_v3.errors.validation.invalid_user_assigned_to_work_package',
                       property: I18n.t('attributes.responsible'))
        expect(validated_contract.errors[:responsible]).to match_array [error]
      end
    end

    context 'if the project is not set' do
      let(:work_package_project) { nil }

      it_behaves_like 'has no error on', :responsible
    end
  end

  describe '#assignable_assignees' do
    it 'returns the Principal`s possible_assignee scope' do
      expect(subject.assignable_assignees)
        .to eql assignable_assignees_scope
    end
  end

  describe '#assignable_responsibles' do
    it 'returns the Principal`s possible_assignee scope' do
      expect(subject.assignable_responsibles)
        .to eql assignable_assignees_scope
    end
  end
end
