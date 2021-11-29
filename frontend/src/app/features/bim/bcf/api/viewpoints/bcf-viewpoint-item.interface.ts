

import { CreateBcfViewpointData } from 'core-app/features/bim/bcf/api/bcf-api.model';

export interface BcfViewpointItem {
  /** The URL of the viewpoint, if persisted */
  href?:string|null;
  /** URL (persisted or data) to the snapshot */
  snapshotURL:string;
  /** The loaded snapshot, if exists */
  viewpoint?:CreateBcfViewpointData;
}
