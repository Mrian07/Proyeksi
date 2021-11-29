

module Bim::Bcf::API::V2_1
  class Viewpoints::SingleRepresenter < BaseRepresenter
    property :lines

    property :bitmaps

    property :snapshot

    property :components

    property :index

    property :orthogonal_camera

    property :perspective_camera

    property :clipping_planes

    def to_json(*)
      represented.read_attribute_before_type_cast('json_viewpoint')
    end
  end
end
