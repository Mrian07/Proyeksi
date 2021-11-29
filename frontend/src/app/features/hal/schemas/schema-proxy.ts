

import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { IFieldSchema } from 'core-app/shared/components/fields/field.base';
import isNewResource from 'core-app/features/hal/helpers/is-new-resource';

export interface ISchemaProxy extends SchemaResource {
  ofProperty(property:string):IFieldSchema;
  isAttributeEditable(property:string):boolean;
  isEditable:boolean;
}

export class SchemaProxy implements ProxyHandler<SchemaResource> {
  constructor(protected schema:SchemaResource,
    protected resource:HalResource) {
  }

  static create(schema:SchemaResource, resource:HalResource) {
    return new Proxy(
      schema,
      new this(schema, resource),
    ) as ISchemaProxy;
  }

  get(schema:SchemaResource, property:PropertyKey, receiver:any):any {
    switch (property) {
      case 'ofProperty': {
        return this.proxyMethod(this.ofProperty);
      }
      case 'isAttributeEditable': {
        return this.proxyMethod(this.isAttributeEditable);
      }
      case 'mappedName': {
        return this.proxyMethod(this.mappedName);
      }
      case 'isEditable': {
        return this.isEditable;
      }
      default: {
        return Reflect.get(schema, property, receiver);
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
  public ofProperty(property:string):IFieldSchema|null {
    const propertySchema = this.schema[this.mappedName(property)];

    if (propertySchema) {
      return { ...propertySchema, writable: this.isEditable && propertySchema && propertySchema.writable };
    }
    return null;
  }

  /**
   * Return whether the resource is editable with the user's permission
   * on the given resource package attribute.
   * In order to be editable, there needs to be an update link on the resource and the schema for
   * the attribute needs to indicate the writability.
   *
   * @param property
   */
  public isAttributeEditable(property:string):boolean {
    const propertySchema = this.ofProperty(property);

    return !!propertySchema && propertySchema.writable;
  }

  /**
   * Return whether the user in general has permission to edit the resource.
   * This check is required, but not sufficient to check all attribute restrictions.
   *
   * Use +isAttributeEditable(property)+ for this case.
   */
  public get isEditable() {
    return isNewResource(this.resource) || !!this.resource.$links.update;
  }

  public mappedName(property:string):string {
    return property;
  }

  private proxyMethod(method:Function) {
    const self = this;

    // Returning a Proxy here so that the call is bound
    // to the SchemaProxy instance.
    return new Proxy(method, {
      apply(_, __, argumentsList) {
        return method.apply(self, [argumentsList[0]]);
      },
    });
  }
}
