

require 'spec_helper'

describe Bim::Bcf::API::V2_1::Viewpoints::SingleRepresenter, 'rendering' do
  let(:struct) do
    OpenStruct.new
  end
  let(:hash) do
    FactoryBot
      .attributes_for(:bcf_viewpoint)[:json_viewpoint]
      .merge(
        "snapshot" =>
          {
            "snapshot_type" => "png",
            "snapshot_data" => "SGVsbG8gV29ybGQh"
          },
        "index" => 5,
        "orthogonal_camera" =>
          {
            "camera_view_point" => {
              "x" => 12.2088897788292,
              "y" => 52.323145074034,
              "z" => 5.24072091171001
            },
            "camera_direction" => {
              "x" => -0.381615611200324,
              "y" => -0.825232810204882,
              "z" => -0.416365617893758
            },
            "camera_up_vector" => {
              "x" => 0.05857014928797,
              "y" => 0.126656300502579,
              "z" => 0.990215996212637
            },
            "field_of_view" => 60.0
          },
        "perspective_camera" => {
          "camera_view_point" => {
            "x" => 183.31539916992188,
            "y" => -183.31539916992188,
            "z" => 183.31539916992188
          },
          "camera_direction" => {
            "x" => -0.5773502588272095,
            "y" => 0.5773502588272095,
            "z" => -0.5773502588272095
          },
          "camera_up_vector" => {
            "x" => -1,
            "y" => 1,
            "z" => 1
          },
          "field_of_view" => 60
        }
      )
  end
  let(:representer) { described_class.new(struct) }

  subject { representer.from_hash(hash).to_h.to_json }

  shared_examples_for 'parses' do |attribute|
    it attribute do
      expect(subject)
        .to be_json_eql(hash[attribute].to_json)
        .at_path(attribute)
    end
  end

  it 'does not parse uuid' do
    expect(subject)
      .not_to have_json_path('guid')
  end

  it_behaves_like 'parses', 'index'

  it_behaves_like 'parses', 'orthogonal_camera'

  it_behaves_like 'parses', 'perspective_camera'

  it_behaves_like 'parses', 'lines'

  it_behaves_like 'parses', 'clipping_planes'

  it_behaves_like 'parses', 'bitmaps' # in order to throw a not writable error)

  it_behaves_like 'parses', 'snapshot'

  it_behaves_like 'parses', 'components'
end
