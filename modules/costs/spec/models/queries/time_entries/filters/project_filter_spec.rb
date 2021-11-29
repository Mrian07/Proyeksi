#-- encoding: UTF-8



require 'spec_helper'

describe Queries::TimeEntries::Filters::ProjectFilter, type: :model do
  let(:project1) { FactoryBot.build_stubbed(:project) }
  let(:project2) { FactoryBot.build_stubbed(:project) }

  before do
    allow(Project)
      .to receive_message_chain(:visible, :pluck)
      .with(:id)
      .and_return([project1.id, project2.id])
  end

  it_behaves_like 'basic query filter' do
    let(:class_key) { :project_id }
    let(:type) { :list_optional }
    let(:name) { TimeEntry.human_attribute_name(:project) }

    describe '#allowed_values' do
      it 'is a list of the possible values' do
        expected = [[project1.id, project1.id.to_s], [project2.id, project2.id.to_s]]

        expect(instance.allowed_values).to match_array(expected)
      end
    end
  end

  it_behaves_like 'list_optional query filter' do
    let(:attribute) { :project_id }
    let(:model) { TimeEntry }
    let(:valid_values) { [project1.id.to_s] }
  end
end
