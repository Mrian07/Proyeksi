

import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';

export class FloatDisplayField extends DisplayField {
  public get valueString():string {
    if (this.value == null) {
      return '';
    }

    return this.value.toLocaleString(
      this.I18n.locale,
      { useGrouping: true, maximumFractionDigits: 20 },
    );
  }
}
