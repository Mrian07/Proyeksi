

import { HalResource } from 'core-app/features/hal/resources/hal-resource';

export class CollectionResource<T = HalResource> extends HalResource {
  public elements:T[];

  public count:number;

  public total:number;

  public pageSize:number;

  public offset:number;

  /**
   * Update the collection's elements and return them in a promise.
   * This is useful, as angular does not recognize update made by $load.
   */
  public updateElements():Promise<unknown> {
    if (this.href) {
      return this.$load().then((collection:this) => this.elements = collection.elements);
    }
    return Promise.resolve();
  }
}
