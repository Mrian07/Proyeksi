

require 'spec_helper'

describe CustomFieldsController do
  let!(:custom_field) { FactoryBot.create(:work_package_custom_field) }
  let!(:custom_field_permanent) { FactoryBot.create(:work_package_custom_field) }
  let(:custom_field_name) { "CustomField#{custom_field.id}" }
  let(:custom_field_permanent_name) { "CustomField#{custom_field_permanent.id}" }
  let(:cost_query) { FactoryBot.build(:cost_query) }

  before do
    allow(@controller).to receive(:authorize)
    allow(@controller).to receive(:check_if_login_required)
    allow(@controller).to receive(:require_admin)

    CostQuery::Filter::CustomFieldEntries.reset!
    CostQuery::Filter::CustomFieldEntries.all

    CostQuery::GroupBy::CustomFieldEntries.reset!
    CostQuery::GroupBy::CustomFieldEntries.all
  end

  describe '#destroy' do
    shared_context 'remove custom field' do
      before do
        cost_query.filter(custom_field_permanent_name, { operator: '=', values: [] })
        cost_query.group_by(custom_field_permanent_name)
        cost_query.save!

        delete :destroy, params: { id: custom_field.id }
      end
    end

    shared_examples_for 'custom field is removed from cost query' do
      include_context 'remove custom field'

      shared_examples_for 'custom field removed' do
        it { expect(subject).not_to include(name) }
      end

      shared_examples_for 'custom field exists' do
        it { expect(subject).to include(name) }
      end

      describe 'custom field is removed from cost query filter' do
        subject { CostQuery.find(cost_query.id).filters.collect(&:class).collect(&:name) }

        it_behaves_like 'custom field removed' do
          let(:name) { "CostQuery::Filter::#{custom_field_name}" }
        end
      end

      describe 'custom field is removed from cost query group bys' do
        subject { CostQuery.find(cost_query.id).group_bys.collect(&:class).collect(&:name) }

        it_behaves_like 'custom field removed' do
          let(:name) { "CostQuery::GroupBy::#{custom_field_name}" }
        end
      end

      describe 'permanent custom field still exists in cost query filter' do
        subject { cost_query.reload.filters.collect(&:class).collect(&:name) }

        it_behaves_like 'custom field exists' do
          let(:name) { "CostQuery::Filter::#{custom_field_permanent_name}" }
        end
      end

      describe 'permanent custom field still exists in cost query group by' do
        subject { cost_query.reload.group_bys.collect(&:class).collect(&:name) }

        it_behaves_like 'custom field exists' do
          let(:name) { "CostQuery::GroupBy::#{custom_field_permanent_name}" }
        end
      end
    end

    context 'with custom field filter set' do
      before do
        cost_query.filter(custom_field_name, { operator: '=', values: [] })
      end

      it_behaves_like 'custom field is removed from cost query'
    end

    context 'with custom field group by set' do
      before do
        cost_query.group_by(custom_field_name)
      end

      it_behaves_like 'custom field is removed from cost query'
    end

    context 'session' do
      let(:engine_name) { CostQuery.name.underscore.to_sym }
      let(:key) { :"custom_field#{custom_field.id}" }
      let(:query) do
        { filters:
                      {
                        operators: { user_id: "=", key => "=" },
                        values: { user_id: ["96"], key => "" }
                      },
          groups: { rows: [key.to_s], columns: [key.to_s] } }
      end
      before { session[engine_name] = query }

      describe 'does not contain custom field reference' do
        include_context 'remove custom field'

        it { expect(session[engine_name][:filters][:operators][key]).to be_nil }

        it { expect(session[engine_name][:filters][:values][key]).to be_nil }

        it { expect(session[engine_name][:groups][:rows]).not_to include(key.to_s) }

        it { expect(session[engine_name][:groups][:columns]).not_to include(key.to_s) }
      end
    end
  end
end
