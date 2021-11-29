

import { I18nService } from 'core-app/core/i18n/i18n.service';
import {
  Component, ElementRef, OnInit, ViewChild,
} from '@angular/core';
import {
  HideSectionDefinition,
  HideSectionService,
} from 'core-app/shared/components/hide-section/hide-section.service';
import { trackByProperty } from 'core-app/shared/helpers/angular/tracking-functions';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';

export const addSectionDropdownSelector = 'add-section-dropdown';

@Component({
  selector: addSectionDropdownSelector,
  templateUrl: './add-section-dropdown.component.html',
})
export class AddSectionDropdownComponent extends UntilDestroyedMixin implements OnInit {
  @ViewChild('fallbackOption', { static: true }) private option:ElementRef;

  trackByKey = trackByProperty('key');

  selectable:HideSectionDefinition[] = [];

  active:string[] = [];

  public htmlId:string;

  public placeholder = this.I18n.t('js.placeholders.selection');

  constructor(protected hideSectionService:HideSectionService,
    protected elementRef:ElementRef,
    protected I18n:I18nService) {
    super();
  }

  ngOnInit():void {
    this.htmlId = this.elementRef.nativeElement.dataset.htmlId;

    this.hideSectionService
      .displayed
      .values$()
      .pipe(
        this.untilDestroyed(),
      ).subscribe((displayed) => {
        this.selectable = this.hideSectionService.all
          .filter((el) => displayed.indexOf(el.key) === -1)
          .sort((a, b) => a.label.localeCompare(b.label));

        (this.option.nativeElement as HTMLOptionElement).selected = true;
      });
  }

  show(value:string) {
    this.hideSectionService.show(value);
  }
}
