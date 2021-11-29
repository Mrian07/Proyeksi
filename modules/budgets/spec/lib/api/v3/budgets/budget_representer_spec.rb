

require 'spec_helper'

describe ::API::V3::Budgets::BudgetRepresenter do
  include ::API::V3::Utilities::PathHelper

  let(:project) { FactoryBot.build(:project, id: 999) }
  let(:user) do
    FactoryBot.create(:user,
                     member_in_project: project,
                     created_at: 1.day.ago,
                     updated_at: Date.today)
  end
  let(:budget) do
    FactoryBot.create(:budget,
                      author: user,
                      project: project,
                      created_at: 1.day.ago,
                      updated_at: Date.today)
  end

  let(:representer) { described_class.new(budget, current_user: user) }

  context 'generation' do
    subject(:generated) { representer.to_json }

    describe 'self link' do
      it_behaves_like 'has a titled link' do
        let(:link) { 'self' }
        let(:href) { api_v3_paths.budget(budget.id) }
        let(:title) { budget.subject }
      end
    end

    it_behaves_like 'has an untitled link' do
      let(:link) { :attachments }
      let(:href) { api_v3_paths.attachments_by_budget budget.id }
    end

    it_behaves_like 'has an untitled action link' do
      let(:link) { :addAttachment }
      let(:href) { api_v3_paths.attachments_by_budget budget.id }
      let(:method) { :post }
      let(:permission) { :edit_budgets }
    end

    it 'indicates its type' do
      is_expected.to be_json_eql('Budget'.to_json).at_path('_type')
    end

    it 'indicates its id' do
      is_expected.to be_json_eql(budget.id.to_json).at_path('id')
    end

    it 'indicates its subject' do
      is_expected.to be_json_eql(budget.subject.to_json).at_path('subject')
    end
  end
end
