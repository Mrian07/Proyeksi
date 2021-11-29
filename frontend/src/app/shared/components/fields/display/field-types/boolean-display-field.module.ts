

import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';

export class BooleanDisplayField extends DisplayField {
  public get valueString() {
    return this.translatedValue();
  }

  public get placeholder() {
    return this.translatedValue();
  }

  public translatedValue() {
    if (this.value) {
      return this.I18n.t('js.general_text_yes');
    }
    return this.I18n.t('js.general_text_no');
  }

  public isEmpty():boolean {
    // We treat an empty value the same as if the user had set
    // the value to false;
    return false;
  }
}
