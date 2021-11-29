#-- encoding: UTF-8



require 'spec_helper'

describe Projects::GanttQueryGeneratorService, type: :model do
  let(:selected) { %w[1 2 3] }
  let(:instance) { described_class.new selected }
  let(:subject) { instance.call }
  let(:json) { JSON.parse(subject) }
  let(:milestone_ids) { [123, 234] }
  let(:default_json) do
    scope = double('scope')
    allow(Type)
      .to receive(:milestone)
      .and_return(scope)

    allow(scope)
      .to receive(:pluck)
      .with(:id)
      .and_return(milestone_ids)

    JSON
      .parse(Projects::GanttQueryGeneratorService::DEFAULT_GANTT_QUERY)
      .merge('f' => [{ 'n' => 'type', 'o' => '=', 'v' => milestone_ids.map(&:to_s) }])
  end

  def build_project_filter(ids)
    { 'n' => 'project', 'o' => '=', 'v' => ids }
  end

  context 'with empty setting' do
    before do
      Setting.project_gantt_query = ''
    end

    it 'uses the default' do
      expected = default_json.deep_dup
      expected['f'] << build_project_filter(selected)
      expect(json).to eq(expected)
    end

    context 'without configured milestones' do
      let(:milestone_ids) { [] }

      it 'uses the default but without the type filter' do
        expected = default_json
                     .deep_dup
                     .merge('f' => [build_project_filter(selected)])
        expect(json).to eq(expected)
      end
    end
  end

  context 'with existing filter' do
    it 'overrides the filter' do
      Setting.project_gantt_query = default_json.deep_dup.merge('f' => [build_project_filter(%w[other values])]).to_json

      expected = default_json.deep_dup.merge('f' => [build_project_filter(selected)])
      expect(json).to eq(expected)
    end
  end

  context 'with invalid json' do
    it 'returns the default' do
      Setting.project_gantt_query = 'invalid!1234'

      expected = default_json.deep_dup
      expected['f'] << build_project_filter(selected)
      expect(json).to eq(expected)
    end
  end
end
