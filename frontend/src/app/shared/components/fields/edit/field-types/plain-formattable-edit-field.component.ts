

import { Component } from '@angular/core';
import { EditFieldComponent } from 'core-app/shared/components/fields/edit/edit-field.component';

@Component({
  templateUrl: './text-edit-field.component.html',
})
export class PlainFormattableEditFieldComponent extends EditFieldComponent {
  // only exists because the template is reused and the property is required there.
  public shouldFocus = false;

  public get value() {
    if (!this.schema) {
      return '';
    }
    const element = this.resource[this.name];

    return element && element.raw || '';
  }

  public set value(newValue:string) {
    this.resource[this.name] = { raw: newValue };
  }
}
