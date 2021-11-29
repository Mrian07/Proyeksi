

require File.dirname(__FILE__) + '/../spec_helper'

describe BudgetsHelper, type: :helper do
  let(:project) { FactoryBot.build(:project) }
  let(:budget) { FactoryBot.build(:budget, project: project) }

  describe '#budgets_to_csv' do
    describe 'WITH a list of one cost object' do
      it 'should output the cost objects attributes' do
        expected = [
          budget.id,
          budget.project.name,
          budget.subject,
          budget.author.name,
          helper.format_date(budget.fixed_date),
          helper.number_to_currency(budget.material_budget),
          helper.number_to_currency(budget.labor_budget),
          helper.number_to_currency(budget.spent),
          helper.format_time(budget.created_at),
          helper.format_time(budget.updated_at),
          budget.description
        ].join(I18n.t(:general_csv_separator))

        expect(budgets_to_csv([budget]).include?(expected)).to be_truthy
      end

      it 'should start with a header explaining the fields' do
        expected = [
          '#',
          Project.model_name.human,
          Budget.human_attribute_name(:subject),
          Budget.human_attribute_name(:author),
          Budget.human_attribute_name(:fixed_date),
          Budget.human_attribute_name(:material_budget),
          Budget.human_attribute_name(:labor_budget),
          Budget.human_attribute_name(:spent),
          Budget.human_attribute_name(:created_at),
          Budget.human_attribute_name(:updated_at),
          Budget.human_attribute_name(:description)
        ].join(I18n.t(:general_csv_separator))

        expect(budgets_to_csv([budget]).start_with?(expected)).to be_truthy
      end
    end
  end
end
