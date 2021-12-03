

require 'spec_helper'

shared_examples 'viewpoint keys' do
  let(:expected) { %w[guid components orthogonal_camera perspective_camera lines clipping_planes bitmaps] }

  it 'has only allowed keys' do
    expect(subject.keys - expected).to be_empty
  end

  it 'always has the guid set to the viewpoint' do
    expect(subject.keys).to include 'guid'
    expect(subject['guid']).to eq(xml_viewpoint.uuid)
  end

  it 'always has the perspective_camera OR orthogonal camera set' do
    expect(subject.keys)
      .to include('perspective_camera')
      .or include('orthogonal_camera')
  end
end

shared_examples 'has camera' do |camera_type|
  it 'has a camera object' do
    # camera xyz floats
    expect(subject.dig(camera_type)).to be_kind_of(Hash)
    expect(subject.dig(camera_type, 'field_of_view')).to be_kind_of(Numeric) if camera_type == 'perspective_camera'
    expect(subject.dig(camera_type, 'view_to_world_scale')).to be_kind_of(Numeric) if camera_type == 'orthogonal_camera'

    %w[camera_view_point camera_direction camera_up_vector].each do |key|
      camera_vp = subject.dig(camera_type, key)
      expect(camera_vp).to be_kind_of(Hash)
      expect(camera_vp.keys).to contain_exactly 'x', 'y', 'z'
      expect(camera_vp.values).to all(be_kind_of(Numeric))
    end
  end
end

shared_examples 'has lines' do
  it 'has a lines entry' do
    lines = subject['lines']
    expect(lines).to be_kind_of(Array)

    lines.each do |line|
      expect(line).to be_kind_of(Hash)
      expect(line.keys).to contain_exactly 'start_point', 'end_point'
      expect(line['start_point'].keys).to contain_exactly 'x', 'y', 'z'
      expect(line['start_point'].values).to all(be_kind_of(Numeric))
      expect(line['end_point'].keys).to contain_exactly 'x', 'y', 'z'
      expect(line['end_point'].values).to all(be_kind_of(Numeric))
    end
  end
end

shared_examples 'has clipping planes' do
  it 'has a lines entry' do
    clipping_planes = subject['clipping_planes']
    expect(clipping_planes).to be_kind_of(Array)

    clipping_planes.each do |plane|
      expect(plane).to be_kind_of(Hash)
      expect(plane.keys).to contain_exactly 'location', 'direction'
      expect(plane['location'].keys).to contain_exactly 'x', 'y', 'z'
      expect(plane['location'].values).to all(be_kind_of(Numeric))
      expect(plane['direction'].keys).to contain_exactly 'x', 'y', 'z'
      expect(plane['direction'].values).to all(be_kind_of(Numeric))
    end
  end
end

shared_examples 'has bitmaps' do
  it 'has a bitmaps entry' do
    bitmaps = subject['bitmaps']
    expect(bitmaps).to be_kind_of(Array)

    bitmaps.each do |bitmap|
      expect(bitmap).to be_kind_of(Hash)
      expect(bitmap.keys).to contain_exactly 'bitmap_type', 'bitmap_data', 'location', 'normal', 'up', 'height'
      expect(bitmap['location'].keys).to contain_exactly 'x', 'y', 'z'
      expect(bitmap['location'].values).to all(be_kind_of(Numeric))
      expect(bitmap['normal'].keys).to contain_exactly 'x', 'y', 'z'
      expect(bitmap['normal'].values).to all(be_kind_of(Numeric))
      expect(bitmap['up'].keys).to contain_exactly 'x', 'y', 'z'
      expect(bitmap['up'].values).to all(be_kind_of(Numeric))
      expect(bitmap['height']).to be_kind_of(Numeric)
    end
  end
end

shared_examples 'has components selection' do
  it 'has components selections' do
    selection = subject.dig('components', 'selection')
    expect(selection).to be_kind_of(Array)

    selection.each do |item|
      expect(item).to be_kind_of(Hash)
      expect(item.keys).to include 'ifc_guid'

      # Has only allowed keys
      expect(item.keys - %w[ifc_guid originating_system authoring_tool_id]).to be_empty
    end
  end
end

shared_examples 'has components coloring' do
  it 'has components coloring' do
    coloring = subject.dig('components', 'coloring')
    expect(coloring).to be_kind_of(Array)

    coloring.each do |item|
      expect(item).to be_kind_of(Hash)
      expect(item.keys).to include 'color', 'components'
      expect(item['color']).to match /\A#[a-f0-9]{6}\Z/i
      expect(item['components']).to be_kind_of(Array)

      item['components'].each do |component|
        expect(component).to be_kind_of(Hash)
        expect(component.keys).to include 'ifc_guid'
      end
    end
  end
end

shared_examples 'has components visibility' do
  it 'has components visibility' do
    visibility = subject.dig('components', 'visibility')
    expect(visibility).to be_kind_of(Hash)
    expect(visibility.keys - %w[default_visibility exceptions view_setup_hints]).to be_empty

    expect(visibility['default_visibility']).to be_boolean
    Array(visibility['exceptions']).each do |item|
      expect(item).to be_kind_of(Hash)
      expect(item.keys).to include 'ifc_guid'
    end

    hints = visibility['view_setup_hints']
    expect(hints).to be_kind_of(Hash)
    expect(hints.keys).to contain_exactly 'spaces_visible', 'space_boundaries_visible', 'openings_visible'
    expect(hints.values).to all(be_boolean)
  end
end

shared_examples 'matches the JSON counterpart' do
  it 'matches the JSON viewpoint counterpart' do
    path = ProyeksiApp::Bim::Engine.root.join("spec/fixtures/viewpoints/#{xml_viewpoint.viewpoint_name}.json")
    raise "Expected #{path} to be readable for JSON comparison" unless path.readable?

    json = path.read

    # Replace the static GUID with the one from this viewpoint
    json.gsub! '{{UUID}}', xml_viewpoint.uuid

    expect(subject.to_json).to be_json_eql(json)
  end
end