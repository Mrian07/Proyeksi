

import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';

export class IntegerDisplayField extends DisplayField {
  public get value() {
    return parseInt(this.resource[this.name]);
  }

  public isEmpty():boolean {
    return isNaN(this.value);
  }
}
