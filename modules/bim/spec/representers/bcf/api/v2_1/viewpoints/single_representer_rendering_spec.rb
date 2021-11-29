

require 'spec_helper'

require_relative '../shared_examples'

describe Bim::Bcf::API::V2_1::Viewpoints::SingleRepresenter, 'rendering' do
  let(:viewpoint) { FactoryBot.build_stubbed(:bcf_viewpoint) }
  let(:instance) { described_class.new(viewpoint) }

  subject { instance.to_json }

  it 'renders only the json_viewpoint attribute (as root)' do
    expect(subject)
      .to be_json_eql(viewpoint.read_attribute_before_type_cast('json_viewpoint'))
  end
end
