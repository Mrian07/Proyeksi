

import { TimelineLabels, TimelineZoomLevel } from 'core-app/features/hal/resources/query-resource';

export interface WorkPackageTimelineState {
  visible:boolean;
  zoomLevel:TimelineZoomLevel;
  labels:TimelineLabels;
}
