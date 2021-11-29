

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import idFromLink from 'core-app/features/hal/helpers/id-from-link';

export class QueryOperatorResource extends HalResource {
  public get id():string {
    return this.$source.id || idFromLink(this.href);
  }

  public set id(val:string) {
    this.$source.id = val;
  }
}
