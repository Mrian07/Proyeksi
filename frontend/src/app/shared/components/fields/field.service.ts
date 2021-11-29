

import { Injector } from '@angular/core';
import { Field } from 'core-app/shared/components/fields/field.base';

export interface IFieldType<T extends Field> {
  fieldType:string;
  $injector:Injector;
  new(...args:any[]):T;
}

export abstract class AbstractFieldService<T extends Field, C extends IFieldType<T>> {
  /** Default field type to fall back to */
  public defaultFieldType:string;

  /** Registered attribute types => field identifier */
  protected fields:{ [attributeType:string]:string } = {};

  /** Registered field classes */
  protected classes:{ [type:string]:C } = {};

  /**
   * Get the field type for the given attribute type.
   * If no registered type exists for the field, returns the default type.
   *
   * @param {string} attributeType
   * @returns {string}
   */
  public fieldType(attributeType:string):string|undefined {
    return this.fields[attributeType];
  }

  /**
   * Get the Field class for the given field name.
   * Returns the default class if no registered type exists
   * @param {string} fieldName
   * @returns {C}
   */
  public getClassFor(fieldName:string, type = 'unknown'):C {
    const key = this.fieldType(fieldName) || this.fieldType(type) || this.defaultFieldType;
    return this.classes[key];
  }

  public getSpecificClassFor(resourceType:string, fieldName:string, type = 'unknown'):C {
    const key = this.fieldType(`${resourceType}-${fieldName}`)
              || this.fieldType(`${resourceType}-${type}`);

    if (key) {
      return this.classes[key];
    }

    return this.getClassFor(fieldName, type);
  }

  /**
   * Add a field class for the given attribute names.
   *
   * @param fieldClass The field class
   * @param {string} fieldType the field type identifier (e.g., 'progress')
   * @param {string[]} attributes The schema attribute names to register for (e.g., 'Progress')
   *
   * @returns {this}
   */
  public addFieldType(fieldClass:any, fieldType:string, attributes:string[]) {
    fieldClass.fieldType = fieldType;
    this.register(fieldClass, attributes);

    return this;
  }

  /**
   * Add a field class for the given attribute names and a specify resource.
   *
   * @param resourceType The resource type (e.g Work Package)
   * @param fieldClass The field class
   * @param {string} fieldType the field type identifier (e.g., 'progress')
   * @param {string[]} attributes The schema attribute names to register for (e.g., 'Progress')
   *
   * @returns {this}
   */
  public addSpecificFieldType(resourceType:string, fieldClass:any, fieldType:string, attributes:string[]) {
    fieldClass.fieldType = `${resourceType}-${fieldType}`;
    attributes = attributes.map((attribute) => `${resourceType}-${attribute}`);
    this.register(fieldClass, attributes);

    return this;
  }

  /**
   * Register new schema attribute names for an existing field type
   *
   * @param {string} fieldType The field type to extend (e.g., 'select')
   * @param {string[]} attributes The attribute schema names to register to the existing fieldType (e.g., 'budget')
   *
   * @returns {this}
   */
  public extendFieldType(fieldType:string, attributes:string[]) {
    const fieldClass = this.classes[fieldType] || this.getClassFor(fieldType);
    return this.addFieldType(fieldClass, fieldType, attributes);
  }

  /**
   * Register the
   * @param {C} fieldClass
   * @param {string[]} fields
   */
  protected register(fieldClass:C, fields:string[] = []) {
    const type = fieldClass.fieldType;
    fields.forEach((field:string) => this.fields[field] = type);
    this.classes[type] = fieldClass;
  }
}
