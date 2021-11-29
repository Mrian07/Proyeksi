

import { ConfirmDialogModalComponent } from 'core-app/shared/components/modals/confirm-dialog/confirm-dialog.modal';
import {
  Component, ElementRef, OnInit, ViewChild,
} from '@angular/core';

@Component({
  templateUrl: './password-confirmation.modal.html',
})
export class PasswordConfirmationModalComponent extends ConfirmDialogModalComponent implements OnInit {
  public password_confirmation:string|null = null;

  @ViewChild('passwordConfirmationField', { static: true }) passwordConfirmationField:ElementRef;

  public ngOnInit() {
    super.ngOnInit();

    this.text.title = I18n.t('js.password_confirmation.title');
    this.text.field_description = I18n.t('js.password_confirmation.field_description');
    this.text.confirm_button = I18n.t('js.button_confirm');
    this.text.password = I18n.t('js.label_password');

    this.closeOnEscape = false;
    this.closeOnOutsideClick = false;
    this.showClose = false;
  }

  public confirmAndClose(evt:JQuery.TriggeredEvent) {
    if (this.passwordValuePresent()) {
      super.confirmAndClose(evt);
    }
  }

  public onOpen(modalElement:JQuery) {
    super.onOpen(modalElement);
    this.passwordConfirmationField.nativeElement.focus();
  }

  public passwordValuePresent() {
    return this.password_confirmation !== null && this.password_confirmation.length > 0;
  }
}
