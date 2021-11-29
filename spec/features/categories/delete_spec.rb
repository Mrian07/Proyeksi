

require 'spec_helper'
require 'features/categories/categories_page'

describe 'Deletion', type: :feature do
  let(:current_user) do
    FactoryBot.create :user,
                      member_in_project: category.project,
                      member_with_permissions: %i[manage_categories]
  end
  let(:category) { FactoryBot.create :category }
  let(:categories_page) { CategoriesPage.new(category.project) }
  let(:delete_button) { 'a.icon-delete' }
  let(:confirm_deletion_button) { 'input[type="submit"]' }

  before { allow(User).to receive(:current).and_return current_user }

  shared_context 'delete category' do
    before do
      categories_page.visit_settings

      expect(page).to have_selector(delete_button)

      find(delete_button).click
    end
  end

  shared_examples_for 'deleted category' do
    it { expect(page).to have_selector('div.generic-table--no-results-container') }

    it { expect(page).to have_no_selector(delete_button) }
  end

  describe 'w/o work package' do
    include_context 'delete category'

    it_behaves_like 'deleted category'
  end

  describe 'with work package' do
    let!(:work_package) do
      FactoryBot.create :work_package,
                        project: category.project,
                        category: category
    end

    include_context 'delete category'

    before do
      expect(page).to have_selector(confirm_deletion_button)

      find(confirm_deletion_button).click
    end

    it_behaves_like 'deleted category'
  end
end
