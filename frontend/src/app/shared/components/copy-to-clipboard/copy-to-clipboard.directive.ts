

import { Component, ElementRef, OnInit } from '@angular/core';
import { ToastService } from 'core-app/shared/components/toaster/toast.service';
import { ConfigurationService } from 'core-app/core/config/configuration.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';

export const copyToClipboardSelector = 'copy-to-clipboard';

@Component({
  template: '',
  selector: copyToClipboardSelector,
})
export class CopyToClipboardDirective implements OnInit {
  public clickTarget:string;

  public clipboardTarget:string;

  private target:JQuery;

  constructor(
    readonly toastService:ToastService,
    readonly elementRef:ElementRef,
    readonly I18n:I18nService,
    readonly ConfigurationService:ConfigurationService,
  ) { }

  ngOnInit() {
    const element = this.elementRef.nativeElement;
    // Get inputs as attributes since this is a bootstrapped directive
    this.clickTarget = element.getAttribute('click-target');
    this.clipboardTarget = element.getAttribute('clipboard-target');

    jQuery(this.clickTarget).on('click', (evt:JQuery.TriggeredEvent) => this.onClick(evt));

    element.classList.add('copy-to-clipboard');
    this.target = jQuery(this.clipboardTarget ? this.clipboardTarget : element);
  }

  addNotification(type:'addSuccess'|'addError', message:string) {
    const notification = this.toastService[type](message);

    // Remove the notification some time later
    setTimeout(() => this.toastService.remove(notification), 5000);
  }

  onClick($event:JQuery.TriggeredEvent) {
    const supported = (document.queryCommandSupported && document.queryCommandSupported('copy'));
    $event.preventDefault();

    // At least select the input for the user
    // even when clipboard API not supported
    this.target.select().focus();

    if (supported) {
      try {
        // Copy it to the clipboard
        if (document.execCommand('copy')) {
          this.addNotification('addSuccess', this.I18n.t('js.clipboard.copied_successful'));
          return;
        }
      } catch (e) {
        console.log(
          `Your browser seems to support the clipboard API, but copying failed: ${e}`,
        );
      }
    }

    this.addNotification('addError', this.I18n.t('js.clipboard.browser_error'));
  }
}
