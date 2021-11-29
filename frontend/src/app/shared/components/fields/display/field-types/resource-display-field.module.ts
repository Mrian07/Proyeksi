

import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';

export class ResourceDisplayField extends DisplayField {
  public get value() {
    if (this.schema) {
      return this.attribute && this.attribute.name;
    }
    return null;
  }
}
