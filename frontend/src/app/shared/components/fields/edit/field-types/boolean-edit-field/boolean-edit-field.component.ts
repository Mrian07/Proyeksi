

import { Component } from '@angular/core';
import { EditFieldComponent } from 'core-app/shared/components/fields/edit/edit-field.component';

@Component({
  template: `
    <input type="checkbox"
           class="inline-edit--field inline-edit--boolean-field"
           [attr.aria-required]="required"
           [checked]="value"
           (change)="updateValue(!value)"
           (keydown)="handler.handleUserKeydown($event)"
           [disabled]="inFlight"
           [id]="handler.htmlId" />
  `,
})
export class BooleanEditFieldComponent extends EditFieldComponent {
  public updateValue(newValue:boolean) {
    this.value = newValue;
    this.handler.handleUserSubmit();
  }
}
