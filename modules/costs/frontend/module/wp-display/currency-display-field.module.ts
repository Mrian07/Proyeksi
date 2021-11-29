

import { DisplayField } from "core-app/shared/components/fields/display/display-field.module";

export class CurrencyDisplayField extends DisplayField {

  public isEmpty():boolean {
    return !this.value ||
            !parseFloat(this.value.match(/\d+/g)[0]);
  }
}

