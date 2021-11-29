

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { ErrorResource, v3ErrorIdentifierMultipleErrors } from 'core-app/features/hal/resources/error-resource';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';

export interface FormResourceLinks<T = HalResource> {
  commit(payload:any):Promise<T>;
}

export interface FormResourceEmbedded {
  schema:SchemaResource;
  validationErrors:{ [attribute:string]:ErrorResource };
}

export class FormResource<T = HalResource> extends HalResource {
  public schema:SchemaResource;

  public validationErrors:{ [attribute:string]:ErrorResource };

  public getErrors():ErrorResource|null {
    const errors = _.values(this.validationErrors);
    const count = errors.length;

    if (count === 0) {
      return null;
    }

    let resource;
    if (count === 1) {
      resource = new ErrorResource(this.injector, errors[0], true, this.halInitializer, 'Error');
    } else {
      resource = new ErrorResource(this.injector, {}, true, this.halInitializer, 'Error');
      resource.errorIdentifier = v3ErrorIdentifierMultipleErrors;
      resource.errors = errors;
    }
    resource.isValidationError = true;
    return resource;
  }
}

export interface FormResource extends FormResourceEmbedded, FormResourceLinks {}
