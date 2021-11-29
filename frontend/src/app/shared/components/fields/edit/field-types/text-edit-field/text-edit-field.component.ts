

import { Component } from '@angular/core';
import { EditFieldComponent } from 'core-app/shared/components/fields/edit/edit-field.component';

@Component({
  templateUrl: '../text-edit-field.component.html',
})
export class TextEditFieldComponent extends EditFieldComponent {
  // ToDo: Work package specific
  public shouldFocus = this.name === 'subject';
}
