

import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';

export class PlainFormattableDisplayField extends DisplayField {
  public get value() {
    if (!this.schema) {
      return null;
    }
    const element = this.resource[this.name];

    return element && element.raw || '';
  }
}
