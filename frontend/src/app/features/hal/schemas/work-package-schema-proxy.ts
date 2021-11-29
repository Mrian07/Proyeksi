

import { SchemaProxy } from 'core-app/features/hal/schemas/schema-proxy';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';

export class WorkPackageSchemaProxy extends SchemaProxy {
  get(schema:SchemaResource, property:PropertyKey, receiver:any):any {
    switch (property) {
      case 'isMilestone': {
        return this.isMilestone;
      }
      case 'isReadonly': {
        return this.isReadonly;
      }
      default: {
        return super.get(schema, property, receiver);
      }
    }
  }

  /**
   * Returns the part of the schema relevant for the provided property.
   *
   * We use it to support the virtual attribute 'combinedDate' which is the combination of the three
   * attributes 'startDate', 'dueDate' and 'scheduleManually'. That combination exists only in the front end
   * and not on the native schema. As a property needs to be writable for us to allow the user editing,
   * we need to mark the writability positively if any of the combined properties are writable.
   *
   * @param property the schema part is desired for
   */
  public ofProperty(property:string) {
    if (property === 'combinedDate') {
      const propertySchema = super.ofProperty('startDate');

      if (!propertySchema) {
        return null;
      }

      propertySchema.writable = propertySchema.writable
        || this.isAttributeEditable('dueDate')
        || this.isAttributeEditable('scheduleManually');

      return propertySchema;
    }
    return super.ofProperty(property);
  }

  public get isReadonly():boolean {
    return this.resource.status?.isReadonly;
  }

  /**
   * Return whether the work package is editable with the user's permission
   * on the given work package attribute.
   *
   * @param property
   */
  public isAttributeEditable(property:string):boolean {
    if (this.isReadonly && property !== 'status') {
      return false;
    } if (['startDate', 'dueDate', 'date'].includes(property)
      && this.resource.scheduleManually) {
      // This is a blatant shortcut but should be adequate.
      return super.isAttributeEditable('scheduleManually');
    }
    return super.isAttributeEditable(property);
  }

  public get isMilestone():boolean {
    return this.schema.hasOwnProperty('date');
  }

  public mappedName(property:string):string {
    if (this.isMilestone && (property === 'startDate' || property === 'dueDate')) {
      return 'date';
    }
    return property;
  }
}
