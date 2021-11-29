#-- encoding: UTF-8



require 'spec_helper'

describe Types::Scopes::Milestone, type: :model do
  let!(:milestone) { FactoryBot.create(:type, is_milestone: true) }
  let!(:other_type) { FactoryBot.create(:type, is_milestone: false) }

  describe '.milestone' do
    subject { Type.milestone }

    it 'returns only milestones' do
      is_expected
        .to match_array [milestone]
    end
  end
end
