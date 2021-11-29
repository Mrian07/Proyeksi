

import { HalResource } from 'core-app/features/hal/resources/hal-resource';

export class VersionResource extends HalResource {
  status:string;

  public definingProject:HalResource;

  public isLocked() {
    return this.status === 'locked';
  }

  public isOpen() {
    return this.status === 'open';
  }

  public isClosed() {
    return this.status === 'closed';
  }
}
