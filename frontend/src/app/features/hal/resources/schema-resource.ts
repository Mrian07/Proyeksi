

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { InputState } from 'reactivestates';

export class SchemaResource extends HalResource {
  public get state():InputState<this> {
    return this.states.schemas.get(this.href as string) as any;
  }

  public get availableAttributes() {
    return _.keys(this.$source).filter((name) => name.indexOf('_') !== 0);
  }

  // Find the attribute name with a matching (localized) name;
  public attributeFromLocalizedName(name:string):string|null {
    let match:string|null = null;

    for (const attribute of this.availableAttributes) {
      const fieldSchema = this[attribute];
      if (fieldSchema?.name === name) {
        match = attribute;
        break;
      }
    }

    return match;
  }
}

export class SchemaAttributeObject<T = HalResource> {
  public type:string;

  public name:string;

  public required:boolean;

  public hasDefault:boolean;

  public writable:boolean;

  public allowedValues:T[] | CollectionResource<T>;
}
