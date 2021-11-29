

import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, ElementRef, Inject, OnInit,
} from '@angular/core';
import { OpModalComponent } from 'core-app/shared/components/modal/modal.component';
import { OpModalLocalsMap } from 'core-app/shared/components/modal/modal.types';
import { OpModalLocalsToken } from 'core-app/shared/components/modal/modal.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { HelpTextResource } from 'core-app/features/hal/resources/help-text-resource';

@Component({
  templateUrl: './help-text.modal.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class AttributeHelpTextModalComponent extends OpModalComponent implements OnInit {
  /* Close on escape? */
  public closeOnEscape = true;

  /* Close on outside click */
  public closeOnOutsideClick = false;

  readonly text = {
    edit: this.I18n.t('js.button_edit'),
    close: this.I18n.t('js.button_close'),
  };

  public helpText:HelpTextResource = this.locals.helpText!;

  constructor(@Inject(OpModalLocalsToken) public locals:OpModalLocalsMap,
    readonly I18n:I18nService,
    readonly cdRef:ChangeDetectorRef,
    readonly elementRef:ElementRef) {
    super(locals, cdRef, elementRef);
  }

  ngOnInit() {
    super.ngOnInit();

    // Load the attachments
    this
      .helpText
      .attachments
      .$load()
      .then(() => this.cdRef.detectChanges());
  }

  public get helpTextLink() {
    if (this.helpText.editText) {
      return this.helpText.editText.$link.href;
    }

    return '';
  }
}
