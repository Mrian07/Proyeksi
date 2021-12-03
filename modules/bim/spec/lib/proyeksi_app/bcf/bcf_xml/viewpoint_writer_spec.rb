

require 'spec_helper'
require 'compare-xml'

describe ProyeksiApp::Bim::BcfXml::ViewpointWriter do
  let(:writer_instance) { described_class.new json_resource }
  let(:reader_instance) { ::ProyeksiApp::Bim::BcfJson::ViewpointReader.new xml_resource.uuid, subject.to_xml }
  let(:xml_comparison) { Nokogiri::XML(xml_resource.viewpoint) }
  let(:json_comparison) { json_resource.raw_json_viewpoint }

  subject { writer_instance.doc }

  shared_examples 'converts back to xml' do
    it 'the output of writer is XML-equal to the provided XML viewpoint' do
      results = CompareXML.equivalent?(
        subject,
        xml_comparison,
        collapse_whitespace: false,
        verbose: true
      )

      if results.length > 0
        puts subject.to_xml
        raise "Expected documents to be equal. Found diffs:\n#{results.join("\n")}"
      end
    end

    it 'contains the root node' do
      expect(writer_instance.doc.at('VisualizationInfo')).to be_present
    end

    it 'goes full circle comparing back to JSON' do
      expect(reader_instance.to_json).to be_json_eql json_comparison
    end
  end

  describe 'with minimal example' do
    let_it_be(:json_resource) do
      FactoryBot.build_stubbed :bcf_viewpoint, uuid: '{{UUID}}', viewpoint_name: 'minimal.bcfv'
    end
    let_it_be(:xml_resource) do
      FactoryBot.build_stubbed :xml_viewpoint, uuid: '{{UUID}}', viewpoint_name: 'minimal.bcfv'
    end

    it_behaves_like 'converts back to xml'
  end

  describe 'with full viewpoint' do
    let_it_be(:json_resource) do
      FactoryBot.build_stubbed :bcf_viewpoint, uuid: '{{UUID}}', viewpoint_name: 'full_viewpoint.bcfv'
    end
    let_it_be(:xml_resource) do
      FactoryBot.build_stubbed :xml_viewpoint, uuid: '{{UUID}}', viewpoint_name: 'full_viewpoint.bcfv'
    end

    it_behaves_like 'converts back to xml'
  end

  describe 'with real-world neuhaus_sc_1 example' do
    let_it_be(:json_resource) do
      FactoryBot.build_stubbed :bcf_viewpoint, uuid: '{{UUID}}', viewpoint_name: 'neubau_sc_1.bcfv'
    end
    let_it_be(:xml_resource) do
      FactoryBot.build_stubbed :xml_viewpoint, uuid: '{{UUID}}', viewpoint_name: 'neubau_sc_1_fixed.bcfv'
    end

    it_behaves_like 'converts back to xml'
  end
end
