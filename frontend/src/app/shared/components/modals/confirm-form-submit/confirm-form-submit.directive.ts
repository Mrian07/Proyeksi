

import { I18nService } from 'core-app/core/i18n/i18n.service';
import { Component, ElementRef, OnInit } from '@angular/core';
import { ConfirmDialogService } from '../confirm-dialog/confirm-dialog.service';

export const confirmFormSubmitSelector = 'confirm-form-submit';

@Component({
  template: '',
  selector: confirmFormSubmitSelector,
})
export class ConfirmFormSubmitController implements OnInit {
  // Allow original form submission after dialog was closed
  public confirmed = false;

  public text = {
    title: this.I18n.t('js.modals.form_submit.title'),
    text: this.I18n.t('js.modals.form_submit.text'),
  };

  private $element:JQuery<HTMLElement>;

  private $form:JQuery<HTMLElement>;

  constructor(readonly element:ElementRef,
    readonly confirmDialog:ConfirmDialogService,
    readonly I18n:I18nService) {
  }

  ngOnInit() {
    this.$element = jQuery<HTMLElement>(this.element.nativeElement);

    if (this.$element.is('form')) {
      this.$form = this.$element;
    } else {
      this.$form = this.$element.closest('form');
    }

    this.$form.on('submit', (evt) => {
      if (!this.confirmed) {
        evt.preventDefault();
        this.openConfirmationDialog();
        return false;
      }

      return true;
    });
  }

  public openConfirmationDialog() {
    this.confirmDialog.confirm({
      text: this.text,
      closeByEscape: true,
      showClose: true,
      closeByDocument: true,
    }).then(() => {
      this.confirmed = true;
      this.$form.trigger('submit');
    })
      .catch(() => this.confirmed = false);
  }
}
