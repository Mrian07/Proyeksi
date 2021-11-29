

require 'spec_helper'

describe PermittedParams, type: :model do
  let(:user) { FactoryBot.build(:user) }

  shared_examples_for 'allows params' do
    let(:params_key) { defined?(hash_key) ? hash_key : attribute }
    let(:params) do
      nested_params = if defined?(nested_key)
                        { nested_key => hash }
                      else
                        hash
                      end

      ac_params = if defined?(flat) && flat
                    nested_params
                  else
                    { params_key => nested_params }
                  end

      ActionController::Parameters.new(ac_params)
    end

    subject { PermittedParams.new(params, user).send(attribute).to_h }

    it do
      expected = defined?(allowed_params) ? allowed_params : hash
      expect(subject).to eq(expected)
    end
  end

  describe '#budget' do
    let(:attribute) { :budget }

    context 'subject' do
      let(:hash) { { 'subject' => 'subject_test' } }

      it_behaves_like 'allows params'
    end

    context 'description' do
      let(:hash) { { 'description' => 'description_test' } }

      it_behaves_like 'allows params'
    end

    context 'fixed_date' do
      let(:hash) { { 'fixed_date' => '2017-03-01' } }

      it_behaves_like 'allows params'
    end

    context 'project_id' do
      let(:hash) { { 'project_id' => 42 } }

      it_behaves_like 'allows params' do
        let(:allowed_params) { {} }
      end
    end

    context 'existing material budget item' do
      let(:hash) do
        { 'existing_material_budget_item_attributes' => { '1' => {
          'units' => '100.0',
          'cost_type_id' => '1',
          'comments' => 'First package',
          'amount' => '5,000.00'
        } } }
      end

      it_behaves_like 'allows params'
    end

    context 'new material budget item' do
      let(:hash) do
        { 'new_material_budget_item_attributes' => { '1' => {
          'units' => '20',
          'cost_type_id' => '2',
          'comments' => 'Macbooks',
          'amount' => '52,000.00'
        } } }
      end

      it_behaves_like 'allows params'
    end

    context 'existing labor budget item' do
      let(:hash) do
        { 'existing_labor_budget_item_attributes' => { '1' => {
          'hours' => '20.0',
          'user_id' => '1',
          'comments' => 'App Setup',
          'amount' => '2000.00'
        } } }
      end

      it_behaves_like 'allows params'
    end

    context 'new labor budget item' do
      let(:hash) do
        { 'new_labor_budget_item_attributes' => { '1' => {
          'hours' => '5.0',
          'user_id' => '2',
          'comments' => 'Overhead',
          'amount' => '400'
        } } }
      end

      it_behaves_like 'allows params'
    end
  end
end
