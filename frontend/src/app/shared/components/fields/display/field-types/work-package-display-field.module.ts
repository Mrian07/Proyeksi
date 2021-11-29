

import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';

export class WorkPackageDisplayField extends DisplayField {
  public text = {
    none: this.I18n.t('js.filter.noneElement'),
  };

  public get value() {
    return this.resource[this.name];
  }

  public get title() {
    if (this.isEmpty()) {
      return this.text.none;
    }
    return this.value.name;
  }

  public get wpId() {
    if (this.isEmpty()) {
      return null;
    }

    if (this.value.$loaded) {
      return this.value.id;
    }

    // Read WP ID from href
    return this.value.href.match(/(\d+)$/)[0];
  }

  public get valueString() {
    // cannot display the type name easily here as it may not be loaded
    return `#${this.wpId} ${this.title}`;
  }

  public isEmpty():boolean {
    return !this.value;
  }

  public get unknownAttribute():boolean {
    return false;
  }
}
