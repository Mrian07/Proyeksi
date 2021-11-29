

import { Injectable, Injector } from '@angular/core';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { AbstractFieldService, IFieldType } from 'core-app/shared/components/fields/field.service';
import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';
import { IFieldSchema } from 'core-app/shared/components/fields/field.base';

export interface IDisplayFieldType extends IFieldType<DisplayField> {
  new(resource:HalResource, attributeType:string, schema:IFieldSchema, context:DisplayFieldContext):DisplayField;
}

export interface DisplayFieldContext {
  /** The injector to use for the context of this field. Relevant for embedded service injection */
  injector:Injector;

  /** Where will the field be rendered? This may result in different styles (Multi select field, e.g.,) */
  container:'table'|'single-view'|'timeline';

  /** Options passed to the display field */
  options:{ [key:string]:any };
}

@Injectable({ providedIn: 'root' })
export class DisplayFieldService extends AbstractFieldService<DisplayField, IDisplayFieldType> {
  /**
   * Create an instance of the field type T given the required arguments
   * with either in descending order:
   *
   *  1. The registered field name (most specific)
   *  2. The registered field for the schema attribute type
   *  3. The default field type
   *
   * @param resource
   * @param {string} fieldName
   * @param {IFieldSchema} schema
   * @param {string} context
   * @returns {T}
   */
  public getField(resource:HalResource, fieldName:string, schema:IFieldSchema, context:DisplayFieldContext):DisplayField {
    const fieldClass = this.getSpecificClassFor(resource._type, fieldName, schema.type);
    const instance = new fieldClass(fieldName, context);
    instance.apply(resource, schema);
    return instance;
  }
}
