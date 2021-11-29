

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { HttpErrorResponse } from '@angular/common/http';

export const v3ErrorIdentifierQueryInvalid = 'urn:openproject-org:api:v3:errors:InvalidQuery';
export const v3ErrorIdentifierMultipleErrors = 'urn:openproject-org:api:v3:errors:MultipleErrors';

export interface IHalErrorBase {
  _type:string;
  message:string;
  errorIdentifier:string;
}

export interface IHalSingleError extends IHalErrorBase {
  _embedded:{
    details:{
      attribute:string;
    }
  }
}

export interface IHalMultipleError extends IHalErrorBase {
  _embedded:{
    errors:IHalSingleError[];
  }
}

export class ErrorResource extends HalResource {
  public errors:any[];

  public message:string;

  public details:any;

  public errorIdentifier:string;

  /** We may get a reference to the underlying http error */
  public httpError?:HttpErrorResponse;

  public isValidationError = false;

  /**
   * Override toString to ensure the resource can
   * be printed nicely on console and in errors
   */
  public toString() {
    return `[ErrorResource ${this.message}]`;
  }

  public get errorMessages():string[] {
    if (this.isMultiErrorMessage()) {
      return this.errors.map((error) => error.message);
    }

    return [this.message];
  }

  public isMultiErrorMessage() {
    return this.errorIdentifier === v3ErrorIdentifierMultipleErrors;
  }

  public getInvolvedAttributes():string[] {
    let columns = [];

    if (this.details) {
      columns = [{ details: this.details }];
    } else if (this.errors) {
      columns = this.errors;
    }

    return _.flatten(columns.map((resource:ErrorResource) => {
      if (resource.errorIdentifier === v3ErrorIdentifierMultipleErrors) {
        return this.extractMultiError(resource)[0];
      }
      return resource.details.attribute;
    }));
  }

  public getMessagesPerAttribute():{ [attribute:string]:string[] } {
    const perAttribute:any = {};

    if (this.details) {
      perAttribute[this.details.attribute] = [this.message];
    } else {
      _.forEach(this.errors, (error:any) => {
        if (error.errorIdentifier === v3ErrorIdentifierMultipleErrors) {
          const [attribute, messages] = this.extractMultiError(error);
          const current = perAttribute[attribute] || [];
          perAttribute[attribute] = current.concat(messages);
        } else if (perAttribute[error.details.attribute]) {
          perAttribute[error.details.attribute].push(error.message);
        } else {
          perAttribute[error.details.attribute] = [error.message];
        }
      });
    }

    return perAttribute;
  }

  protected extractMultiError(resource:ErrorResource):[string, string[]] {
    const { attribute } = resource.errors[0].details;
    const messages = resource.errors.map((el:ErrorResource) => el.message);

    return [attribute, messages];
  }
}
