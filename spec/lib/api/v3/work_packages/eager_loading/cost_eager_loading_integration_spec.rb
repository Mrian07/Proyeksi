

require 'spec_helper'

describe ::API::V3::WorkPackages::WorkPackageEagerLoadingWrapper, 'cost eager loading', type: :model do
  let(:project) do
    work_package.project
  end
  let(:role) do
    FactoryBot.create(:role,
                      permissions: %i[view_work_packages
                                      view_cost_entries
                                      view_cost_rates
                                      view_time_entries
                                      log_time
                                      log_costs
                                      view_hourly_rates])
  end
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end

  let(:cost_type) do
    FactoryBot.create(:cost_type)
  end
  let(:work_package) do
    FactoryBot.create(:work_package)
  end
  let(:cost_entry1) do
    FactoryBot.create(:cost_entry,
                      cost_type: cost_type,
                      user: user,
                      work_package: work_package,
                      project: project)
  end
  let(:cost_entry2) do
    FactoryBot.create(:cost_entry,
                      cost_type: cost_type,
                      user: user,
                      work_package: work_package,
                      project: project)
  end
  let(:time_entry1) do
    FactoryBot.create(:time_entry,
                      user: user,
                      project: project,
                      work_package: work_package)
  end
  let(:time_entry2) do
    FactoryBot.create(:time_entry,
                      user: user,
                      project: project,
                      work_package: work_package)
  end
  let(:user_rates) do
    FactoryBot.create(:hourly_rate,
                      user: user,
                      project: project)
  end
  let(:cost_rate) do
    FactoryBot.create(:cost_rate,
                      cost_type: cost_type)
  end

  context "combining core's and cost's eager loading" do
    let(:scope) do
      API::V3::WorkPackages::WorkPackageEagerLoadingWrapper.wrap([work_package.id], user)
    end

    before do
      login_as(user)

      user_rates
      project.reload
      cost_rate
      cost_entry1
      cost_entry2
      time_entry1
      time_entry2
    end

    it 'correctly calculates spent time' do
      expect(scope.to_a.first.hours).to eql time_entry1.hours + time_entry2.hours
    end

    it 'correctly calculates labor costs' do
      expect(scope.first.labor_costs).to eql (user_rates.rate * (time_entry1.hours + time_entry2.hours)).to_f
    end

    it 'correctly calculates material costs' do
      expect(scope.first.material_costs).to eql (cost_entry1.costs + cost_entry2.costs).to_f
    end
  end
end
