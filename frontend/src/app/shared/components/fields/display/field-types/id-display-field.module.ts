

import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';
import isNewResource from 'core-app/features/hal/helpers/is-new-resource';

export class IdDisplayField extends DisplayField {
  public text = {
    linkTitle: this.I18n.t('js.work_packages.message_successful_show_in_fullscreen'),
  };

  public get value() {
    if (isNewResource(this.resource)) {
      return null;
    }
    return this.resource[this.name];
  }

  public render(element:HTMLElement, displayText:string):void {
    if (!this.value) {
      return;
    }
    element.textContent = displayText;
  }

  public isEmpty():boolean {
    return false;
  }
}
