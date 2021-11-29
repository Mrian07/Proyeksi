

import { HalResource } from 'core-app/features/hal/resources/hal-resource';

export class SchemaDependencyResource extends HalResource {
  public dependencies:any;

  public forValue(value:string):any {
    return this.dependencies[value];
  }
}
