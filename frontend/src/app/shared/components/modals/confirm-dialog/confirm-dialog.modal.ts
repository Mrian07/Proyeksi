

import {
  ChangeDetectorRef, Component, ElementRef, Inject,
} from '@angular/core';
import { OpModalComponent } from 'core-app/shared/components/modal/modal.component';
import { OpModalLocalsToken } from 'core-app/shared/components/modal/modal.service';
import { OpModalLocalsMap } from 'core-app/shared/components/modal/modal.types';
import { I18nService } from 'core-app/core/i18n/i18n.service';

export interface ConfirmDialogOptions {
  text:{
    title:string;
    text:string;
    button_continue?:string;
    button_cancel?:string;
  };
  closeByEscape?:boolean;
  showClose?:boolean;
  closeByDocument?:boolean;
  passedData?:string[];
  dangerHighlighting?:boolean;
}

@Component({
  templateUrl: './confirm-dialog.modal.html',
})
export class ConfirmDialogModalComponent extends OpModalComponent {
  public showClose:boolean;

  public confirmed = false;

  private options:ConfirmDialogOptions;

  public text:any = {
    title: this.I18n.t('js.modals.form_submit.title'),
    text: this.I18n.t('js.modals.form_submit.text'),
    button_continue: this.I18n.t('js.button_continue'),
    button_cancel: this.I18n.t('js.button_cancel'),
    close_popup: this.I18n.t('js.close_popup_title'),
  };

  public passedData:string[];

  public dangerHighlighting:boolean;

  constructor(readonly elementRef:ElementRef,
    @Inject(OpModalLocalsToken) public locals:OpModalLocalsMap,
    readonly cdRef:ChangeDetectorRef,
    readonly I18n:I18nService) {
    super(locals, cdRef, elementRef);
    this.options = locals.options || {};

    this.dangerHighlighting = _.defaultTo(this.options.dangerHighlighting, false);
    this.passedData = _.defaultTo(this.options.passedData, []);
    this.closeOnEscape = _.defaultTo(this.options.closeByEscape, true);
    this.closeOnOutsideClick = _.defaultTo(this.options.closeByDocument, true);
    this.showClose = _.defaultTo(this.options.showClose, true);
    // override default texts if any
    this.text = _.defaults(this.options.text, this.text);
  }

  public confirmAndClose(evt:JQuery.TriggeredEvent) {
    this.confirmed = true;
    this.closeMe(evt);
  }
}
