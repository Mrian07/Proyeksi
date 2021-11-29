

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';

export class AttachmentCollectionResource extends CollectionResource {
  public $initialize(source:any) {
    super.$initialize(source);

    this.elements = this.elements || [];
  }
}

export interface AttachmentCollectionResource {
  elements:HalResource[];
}
