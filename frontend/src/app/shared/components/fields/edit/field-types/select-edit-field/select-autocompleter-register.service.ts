

import { Injectable } from '@angular/core';

interface SelectAutocompleterAssignment {
  attribute:string;
  component:string;
}

@Injectable({ providedIn: 'root' })
export class SelectAutocompleterRegisterService {
  private _fields:SelectAutocompleterAssignment[] = [];

  public register(component:any, attribute:string) {
    this._fields.push({ attribute, component });
  }

  public getAutocompleterOfAttribute(attribute:string) {
    const assignment = _.find(this._fields, (field) => field.attribute === attribute);
    return assignment ? assignment.component : undefined;
  }
}
