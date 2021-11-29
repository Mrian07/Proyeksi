

import { Component } from '@angular/core';
import { EditFieldComponent } from 'core-app/shared/components/fields/edit/edit-field.component';

@Component({
  template: `
    <input type="number"
           class="inline-edit--field op-input"
           [attr.aria-required]="required"
           [attr.required]="required"
           [disabled]="inFlight"
           [attr.lang]="locale"
           [(ngModel)]="value"
           (keydown)="handler.handleUserKeydown($event)"
           (focusout)="handler.onFocusOut()"
           [id]="handler.htmlId" />
  `,
})
export class IntegerEditFieldComponent extends EditFieldComponent {
  public locale = I18n.locale;
}
