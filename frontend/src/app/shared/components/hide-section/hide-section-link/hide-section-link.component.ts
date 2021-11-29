

import { Component, ElementRef, OnInit } from '@angular/core';
import { HideSectionService } from 'core-app/shared/components/hide-section/hide-section.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';

export const hideSectionLinkSelector = 'hide-section-link';

@Component({
  selector: hideSectionLinkSelector,
  templateUrl: './hide-section-link.component.html',
})
export class HideSectionLinkComponent implements OnInit {
  displayed = true;

  public sectionName:string;

  text = {
    remove: this.I18n.t('js.label_remove'),
  };

  constructor(protected elementRef:ElementRef,
    protected hideSectionService:HideSectionService,
    protected I18n:I18nService) {}

  ngOnInit():void {
    this.sectionName = this.elementRef.nativeElement.dataset.sectionName;
  }

  hideSection() {
    this.hideSectionService.hide(this.sectionName);
    return false;
  }
}
