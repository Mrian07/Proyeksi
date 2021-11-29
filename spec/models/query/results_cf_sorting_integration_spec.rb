

require 'spec_helper'

describe ::Query::Results, 'Sorting of custom field floats', type: :model, with_mail: false do
  let(:query_results) do
    ::Query::Results.new query
  end
  let(:user) do
    FactoryBot.create(:user,
                      firstname: 'user',
                      lastname: '1',
                      member_in_project: project,
                      member_with_permissions: [:view_work_packages])
  end

  let(:type) { FactoryBot.create(:type_standard, custom_fields: [custom_field]) }
  let(:project) do
    FactoryBot.create :project,
                      types: [type],
                      work_package_custom_fields: [custom_field]
  end
  let(:work_package_with_float) do
    FactoryBot.create :work_package,
                      type: type,
                      project: project,
                      custom_values: { custom_field.id => "6.25" }
  end

  let(:work_package_without_float) do
    FactoryBot.create :work_package,
                      type: type,
                      project: project
  end

  let(:custom_field) do
    FactoryBot.create(:float_wp_custom_field, name: 'MyFloat')
  end

  let(:query) do
    FactoryBot.build(:query,
                     user: user,
                     show_hierarchies: false,
                     project: project).tap do |q|
      q.filters.clear
      q.sort_criteria = sort_criteria
    end
  end

  before do
    login_as(user)
    work_package_with_float
    work_package_without_float
  end

  describe 'sorting ASC by float cf' do
    let(:sort_criteria) { [["cf_#{custom_field.id}", 'asc']] }

    it 'returns the correctly sorted result' do
      expect(query_results.work_packages.pluck(:id))
        .to match [work_package_without_float, work_package_with_float].map(&:id)
    end
  end

  describe 'sorting DESC by float cf' do
    let(:sort_criteria) { [["cf_#{custom_field.id}", 'desc']] }

    it 'returns the correctly sorted result' do
      expect(query_results.work_packages.pluck(:id))
        .to match [work_package_with_float, work_package_without_float].map(&:id)
    end
  end
end
