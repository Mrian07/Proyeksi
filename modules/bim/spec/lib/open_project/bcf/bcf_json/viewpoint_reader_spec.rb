

require 'spec_helper'
require_relative './viewpoint_reader_shared_examples'

describe OpenProject::Bim::BcfJson::ViewpointReader do
  let(:instance) { described_class.new xml_viewpoint.uuid, xml_viewpoint.viewpoint }
  subject { instance.result }

  describe 'with empty example' do
    let_it_be(:xml_viewpoint) do
      FactoryBot.build_stubbed :xml_viewpoint, viewpoint_name: 'empty.bcfv'
    end

    it_behaves_like 'matches the JSON counterpart'
  end

  describe 'with minimal example' do
    let_it_be(:xml_viewpoint) do
      FactoryBot.build_stubbed :xml_viewpoint, viewpoint_name: 'minimal.bcfv'
    end

    it_behaves_like 'viewpoint keys'
    it_behaves_like 'has camera', 'orthogonal_camera'

    it_behaves_like 'matches the JSON counterpart'
  end

  describe 'with full viewpoint' do
    let_it_be(:xml_viewpoint) do
      FactoryBot.build_stubbed :xml_viewpoint, viewpoint_name: 'full_viewpoint.bcfv'
    end

    it_behaves_like 'viewpoint keys'
    it_behaves_like 'has camera', 'perspective_camera'
    it_behaves_like 'has lines'
    it_behaves_like 'has clipping planes'
    it_behaves_like 'has bitmaps'
    it_behaves_like 'has components selection'
    it_behaves_like 'has components coloring'
    it_behaves_like 'has components visibility'

    it_behaves_like 'matches the JSON counterpart'
  end

  describe 'with real-world neuhaus_sc_1 example' do
    let_it_be(:xml_viewpoint) do
      FactoryBot.build_stubbed :xml_viewpoint, viewpoint_name: 'neubau_sc_1.bcfv'
    end

    it_behaves_like 'viewpoint keys'
    it_behaves_like 'has camera', 'perspective_camera'
    it_behaves_like 'has components selection'

    it_behaves_like 'matches the JSON counterpart'
  end

  describe 'with empty XML nodes' do
    let_it_be(:xml_viewpoint) do
      FactoryBot.build_stubbed :xml_viewpoint, viewpoint_name: 'empty_nodes.bcfv'
    end

    it 'ignores empty nodes' do
      expect(subject['lines']).to be_nil
      expect(subject['clipping_planes']).to be_nil
      expect(subject.dig('components', 'coloring')).to be_nil
    end
  end
end
