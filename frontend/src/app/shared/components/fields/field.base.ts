

import { DisplayFieldContext } from 'core-app/shared/components/fields/display/display-field.service';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';

export interface IFieldSchema {
  type:string;
  writable:boolean;
  allowedValues?:any;
  required?:boolean;
  hasDefault:boolean;
  name?:string;
  options?:any;
}

export class Field extends UntilDestroyedMixin {
  public static type:string;

  public resource:any;

  public name:string;

  public schema:IFieldSchema;

  public context:DisplayFieldContext;

  public get displayName():string {
    return this.schema.name || this.name;
  }

  public get value() {
    return this.resource[this.name];
  }

  public get type():string {
    return (this.constructor as typeof Field).type;
  }

  public get required():boolean {
    return !!this.schema.required;
  }

  public get writable():boolean {
    return this.schema.writable && this.context.options.writable !== false;
  }

  public get hasDefault():boolean {
    return this.schema.hasDefault;
  }

  public get options():boolean {
    return this.schema.options;
  }

  public isEmpty():boolean {
    return this.value === undefined || this.value === null || this.value === '';
  }

  public get unknownAttribute():boolean {
    return this.isEmpty() && !this.schema;
  }
}
