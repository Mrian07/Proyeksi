

require File.dirname(__FILE__) + '/../spec_helper'

describe LaborBudgetItem, type: :model do
  let(:item) { FactoryBot.build(:labor_budget_item, budget: budget, user: user) }
  let(:budget) { FactoryBot.build(:budget, project: project) }
  let(:user) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:rate) do
    FactoryBot.create(:hourly_rate, user: user,
                                    valid_from: Date.today - 4.days,
                                    rate: 400.0,
                                    project: project)
  end
  let(:project) { FactoryBot.create(:valid_project) }
  let(:project2) { FactoryBot.create(:valid_project) }

  def is_member(project, user, permissions)
    FactoryBot.create(:member,
                      project: project,
                      user: user,
                      roles: [FactoryBot.create(:role, permissions: permissions)])
  end

  describe '#calculated_costs' do
    let(:default_costs) { '0.0'.to_f }

    describe 'WHEN no user is associated' do
      before do
        item.user = nil
      end

      it { expect(item.calculated_costs).to eq(default_costs) }
    end

    describe 'WHEN no hours are defined' do
      before do
        item.hours = nil
      end

      it { expect(item.calculated_costs).to eq(default_costs) }
    end

    describe 'WHEN user, hours and rate are defined' do
      before do
        project.save!
        item.hours = 5.0
        item.user = user
        rate.rate = 400.0
        rate.save!
      end

      it { expect(item.calculated_costs).to eq(rate.rate * item.hours) }
    end

    describe "WHEN user, hours and rate are defined
              WHEN the user is deleted" do
      before do
        project.save!
        item.hours = 5.0
        item.user = user
        rate.rate = 400.0
        rate.save!

        user.destroy
      end

      it { expect(item.calculated_costs).to eq(rate.rate * item.hours) }
    end
  end

  describe '#user' do
    describe 'WHEN an existing user is provided' do
      before do
        item.save!
        item.reload
        item.update_attribute(:user_id, user.id)
        item.reload
      end

      it { expect(item.user).to eq(user) }
    end

    describe 'WHEN a group is provided' do
      let(:group) { FactoryBot.create :group }

      before do
        item.save!
        item.reload
        item.update_attribute(:user_id, group.id)
        item.reload
      end

      it { expect(item.principal).to eq(group) }
    end

    describe 'WHEN a non existing user is provided (i.e. the user has been deleted)' do
      before do
        item.save!
        item.reload
        item.update_attribute(:user_id, user.id)
        user.destroy
        item.reload
      end

      it { expect(item.user).to eq(DeletedUser.first) }
      it { expect(item.user_id).to eq(user.id) }
    end
  end

  describe '#valid?' do
    describe 'WHEN hours, budget and user are provided' do
      it 'should be valid' do
        expect(item).to be_valid
      end
    end

    describe 'WHEN no hours are provided' do
      before do
        item.hours = nil
      end

      it 'should not be valid' do
        expect(item).not_to be_valid
        expect(item.errors[:hours]).to eq([I18n.t('activerecord.errors.messages.not_a_number')])
      end
    end

    describe 'WHEN hours are provided as nontransformable string' do
      before do
        item.hours = 'test'
      end

      it 'should not be valid' do
        expect(item).not_to be_valid
        expect(item.errors[:hours]).to eq([I18n.t('activerecord.errors.messages.not_a_number')])
      end
    end

    describe 'WHEN no budget is provided' do
      before do
        item.budget = nil
      end

      it 'should not be valid' do
        expect(item).not_to be_valid
        expect(item.errors[:budget]).to eq([I18n.t('activerecord.errors.messages.blank')])
      end
    end

    describe 'WHEN no user is provided' do
      before do
        item.user = nil
      end

      it 'should not be valid' do
        expect(item).not_to be_valid
        expect(item.errors[:user]).to eq([I18n.t('activerecord.errors.messages.blank')])
      end
    end
  end

  describe '#costs_visible_by?' do
    before do
      project.enabled_module_names = project.enabled_module_names << 'costs'
    end

    describe "WHEN the item is assigned to the user
              WHEN the user has the view_own_hourly_rate permission" do
      before do
        is_member(project, user, [:view_own_hourly_rate])

        item.user = user
      end

      it { expect(item.costs_visible_by?(user)).to be_truthy }
    end

    describe "WHEN the item is assigned to the user
              WHEN the user lacks permissions" do
      before do
        is_member(project, user, [])

        item.user = user
      end

      it { expect(item.costs_visible_by?(user)).to be_falsey }
    end

    describe "WHEN the item is assigned to another user
              WHEN the user has the view_hourly_rates permission" do
      before do
        is_member(project, user2, [:view_hourly_rates])

        item.user = user
      end

      it { expect(item.costs_visible_by?(user2)).to be_truthy }
    end

    describe "WHEN the item is assigned to another user
              WHEN the user has the view_hourly_rates permission in another project" do
      before do
        is_member(project2, user2, [:view_hourly_rates])

        item.user = user
      end

      it { expect(item.costs_visible_by?(user2)).to be_falsey }
    end
  end
end
