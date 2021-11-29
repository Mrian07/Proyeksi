

import {
  AfterViewInit, ChangeDetectorRef, Component, ElementRef, Inject, ViewChild,
} from '@angular/core';
import { OpModalComponent } from 'core-app/shared/components/modal/modal.component';
import { OpModalLocalsToken } from 'core-app/shared/components/modal/modal.service';
import { OpModalLocalsMap } from 'core-app/shared/components/modal/modal.types';
import { I18nService } from 'core-app/core/i18n/i18n.service';

@Component({
  templateUrl: './wiki-include-page-macro.modal.html',
})
export class WikiIncludePageMacroModalComponent extends OpModalComponent implements AfterViewInit {
  public changed = false;

  public showClose = true;

  public closeOnEscape = true;

  public closeOnOutsideClick = true;

  public selectedPage:string;

  public page = '';

  @ViewChild('selectedPageInput', { static: true }) selectedPageInput:ElementRef;

  public text:any = {
    title: this.I18n.t('js.editor.macro.wiki_page_include.button'),
    hint: this.I18n.t('js.editor.macro.wiki_page_include.hint'),
    page: this.I18n.t('js.editor.macro.wiki_page_include.page'),
    button_save: this.I18n.t('js.button_save'),
    button_cancel: this.I18n.t('js.button_cancel'),
    close_popup: this.I18n.t('js.close_popup_title'),
  };

  constructor(readonly elementRef:ElementRef,
    @Inject(OpModalLocalsToken) public locals:OpModalLocalsMap,
    readonly cdRef:ChangeDetectorRef,
    readonly I18n:I18nService) {
    super(locals, cdRef, elementRef);
    this.selectedPage = this.page = this.locals.page;

    // We could provide an autocompleter here to get correct page names
  }

  public applyAndClose(evt:JQuery.TriggeredEvent) {
    this.changed = true;
    this.page = this.selectedPage;
    this.closeMe(evt);
  }

  ngAfterViewInit() {
    this.selectedPageInput.nativeElement.focus();
  }
}
