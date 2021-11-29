

require 'spec_helper'

describe ::Query::Results, 'Subject filter integration', type: :model, with_mail: false do
  let(:query_results) do
    ::Query::Results.new query
  end
  let(:project_1) { FactoryBot.create :project }
  let(:user_1) do
    FactoryBot.create(:user,
                      firstname: 'user',
                      lastname: '1',
                      member_in_project: project_1,
                      member_with_permissions: [:view_work_packages])
  end

  let!(:contains_wp) do
    FactoryBot.create(:work_package,
                      subject: 'The quick brown fox jumped',
                      project: project_1)
  end
  let!(:contains_reversed_wp) do
    FactoryBot.create(:work_package,
                      subject: 'The quick brown fox jumped',
                      project: project_1)
  end
  let!(:partially_contains_wp) do
    FactoryBot.create(:work_package,
                      subject: 'The quick brown goose jumped',
                      project: project_1)
  end
  let!(:not_contains_wp) do
    FactoryBot.create(:work_package,
                      subject: 'Something completely different',
                      project: project_1)
  end

  let(:query) do
    FactoryBot.build(:query,
                     user: user_1,
                     show_hierarchies: false,
                     project: project_1).tap do |q|
      q.filters.clear
    end
  end

  before do
    query.add_filter('subject', operator, values)

    login_as(user_1)
  end

  describe 'searching for contains' do
    let(:operator) { '~' }
    let(:values) { ['quick fox'] }

    it 'returns the work packages containing the string regardless of order' do
      expect(query_results.work_packages)
        .to match_array [contains_wp, contains_reversed_wp]
    end
  end

  describe 'searching for not contains' do
    let(:operator) { '!~' }
    let(:values) { ['quick fox'] }

    it 'returns the work packages not containing the string regardless of order' do
      expect(query_results.work_packages)
        .to match_array [not_contains_wp, partially_contains_wp]
    end
  end
end
