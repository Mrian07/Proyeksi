

import { Component } from '@angular/core';
import { EditFieldComponent } from 'core-app/shared/components/fields/edit/edit-field.component';

@Component({
  template: `
    <input type="number"
           step="any"
           class="inline-edit--field op-input"
           [attr.aria-required]="required"
           [attr.required]="required"
           [disabled]="inFlight"
           [(ngModel)]="value"
           (keydown)="handler.handleUserKeydown($event)"
           (focusout)="handler.onFocusOut()"
           [attr.lang]="locale"
           [id]="handler.htmlId" />
  `,
})
export class FloatEditFieldComponent extends EditFieldComponent {
  public locale = I18n.locale;
}
