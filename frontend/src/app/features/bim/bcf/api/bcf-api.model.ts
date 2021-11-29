

export type BcfViewpointData = BcfViewpoint&{
  components:BcfViewpointVisibility&BcfViewpointSelection
};

export type CreateBcfViewpointData = BcfViewpointData&{
  snapshot:{ snapshot_type:string, snapshot_data:string }
};

export interface BcfViewpoint {
  index:number|null
  guid:string
  orthogonal_camera:BcfOrthogonalCamera|null
  perspective_camera:BcfPerspectiveCamera|null
  lines:BcfLine[]|null
  clipping_planes:BcfClippingPlane[]|null
  bitmaps:BcfBitmap[]|null
  snapshot:{ snapshot_type:string }
}

export interface BcfViewpointVisibility {
  visibility:{
    default_visibility:boolean
    exceptions:BcfComponent[]
    view_setup_hints:BcfViewSetupHints|null
  }
}

export interface BcfViewpointSelection {
  selection:BcfComponent[]
}

export interface BcfComponent {
  ifc_guid:string|null
  originating_system:string|null
  authoring_tool_id:string|null
}

export interface BcfViewSetupHints {
  spaces_visible:boolean
  space_boundaries_visible:boolean
  openings_visible:boolean
}

export interface BcfOrthogonalCamera {
  camera_view_point:{ x:number, y:number, z:number }
  camera_direction:{ x:number, y:number, z:number }
  camera_up_vector:{ x:number, y:number, z:number }
  view_to_world_scale:number
}

export interface BcfPerspectiveCamera {
  camera_view_point:{ x:number, y:number, z:number }
  camera_direction:{ x:number, y:number, z:number }
  camera_up_vector:{ x:number, y:number, z:number }
  field_of_view:number
}

export interface BcfBitmap {
  guid:string
  bitmap_type:string
  location:{ x:number, y:number, z:number }
  normal:{ x:number, y:number, z:number }
  up:{ x:number, y:number, z:number }
  height:number
}

export interface BcfClippingPlane {
  location:{ x:number, y:number, z:number }
  direction:{ x:number, y:number, z:number }
}

export interface BcfLine {
  start_point:{ x:number, y:number, z:number }
  end_point:{ x:number, y:number, z:number }
}
