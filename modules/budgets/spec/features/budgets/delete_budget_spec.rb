

require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper.rb")

describe 'Deleting a budget', type: :feature, js: true do
  let(:project) { FactoryBot.create :project, enabled_module_names: %i[budgets costs] }
  let(:user) { FactoryBot.create :admin }
  let(:budget_subject) { "A budget subject" }
  let(:budget_description) { "A budget description" }
  let!(:budget) do
    FactoryBot.create :budget,
                      subject: budget_subject,
                      description: budget_description,
                      author: user,
                      project: project
  end

  let(:budget_page) { Pages::EditBudget.new budget.id }
  let(:budget_index_page) { Pages::IndexBudget.new project }

  before do
    login_as(user)
    budget_page.visit!
  end

  context 'when no WP are assigned to this budget' do
    it 'simply deletes the budget without additional checks' do
      # Delete the budget
      budget_page.click_delete

      # Get directly back to index page and the budget is deleted
      budget_index_page.expect_budget_not_listed budget_subject
    end
  end

  context 'when WPs are assigned to this budget' do
    let(:wp1) { FactoryBot.create :work_package, project: project, budget: budget }
    let(:wp2) { FactoryBot.create :work_package, project: project, budget: budget }
    let(:budget_destroy_info_page) { Pages::DestroyInfo.new budget }

    before do
      wp1
      wp2
    end

    context 'with no other budget to assign to' do
      before do
        # When deleting with WPs assigned we get to the destroy_info page
        budget_page.click_delete
        budget_destroy_info_page.expect_loaded

        # In any case the delete option is shown
        budget_destroy_info_page.expect_delete_option
      end

      it 'deletes the budget from the WPs' do
        # Select to delete the budget from the WPs
        budget_destroy_info_page.expect_no_reassign_option
        budget_destroy_info_page.select_delete_option

        # Delete the budget
        budget_destroy_info_page.delete

        # Get back to index page and the budget is deleted
        budget_index_page.expect_budget_not_listed budget_subject

        # Both WPs are updated correctly
        wp1.reload
        wp2.reload
        expect(wp1.budget).to eq nil
        expect(wp2.budget).to eq nil
      end
    end

    context 'with another budget to assign to' do
      let(:budget2) do
        FactoryBot.create :budget,
                          subject: 'Another budget',
                          description: budget_description,
                          author: user,
                          project: project
      end

      before do
        budget2

        # When deleting with WPs assigned we get to the destroy_info page
        budget_page.click_delete
        budget_destroy_info_page.expect_loaded

        # In any case the delete option is shown
        budget_destroy_info_page.expect_delete_option
      end

      it 'reassigns the WP to another budget' do
        # Select reassign
        budget_destroy_info_page.expect_reassign_option
        budget_destroy_info_page.select_reassign_option budget2.subject

        # Delete the budget
        budget_destroy_info_page.delete

        # Get back to index page and the budget is deleted
        budget_index_page.expect_budget_not_listed budget_subject

        # Both WPs are updated correctly
        wp1.reload
        wp2.reload
        expect(wp1.budget.id).to eq budget2.id
        expect(wp2.budget.id).to eq budget2.id
      end
    end
  end
end
