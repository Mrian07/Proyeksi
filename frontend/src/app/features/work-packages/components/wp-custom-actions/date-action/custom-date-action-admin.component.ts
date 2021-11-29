

import {
  ApplicationRef, ChangeDetectorRef, Component, ElementRef, OnInit,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';

export const customDateActionAdminSelector = 'custom-date-action-admin';

@Component({
  selector: customDateActionAdminSelector,
  templateUrl: './custom-date-action-admin.html',
})
export class CustomDateActionAdminComponent implements OnInit {
  public valueVisible = false;

  public fieldName:string;

  public fieldValue:string;

  public visibleValue:string;

  public selectedOperator:any;

  private onKey = 'on';

  private currentKey = 'current';

  private currentFieldValue = '%CURRENT_DATE%';

  public operators = [
    { key: this.onKey, label: this.I18n.t('js.custom_actions.date.specific') },
    { key: this.currentKey, label: this.I18n.t('js.custom_actions.date.current_date') },
  ];

  constructor(private elementRef:ElementRef,
    private cdRef:ChangeDetectorRef,
    public appRef:ApplicationRef,
    private I18n:I18nService) {
  }

  // cannot use $onInit as it would be called before the operators gets filled
  public ngOnInit() {
    const element = this.elementRef.nativeElement as HTMLElement;
    this.fieldName = element.dataset.fieldName!;
    this.fieldValue = element.dataset.fieldValue!;

    if (this.fieldValue === this.currentFieldValue) {
      this.selectedOperator = this.operators[1];
    } else {
      this.selectedOperator = this.operators[0];
      this.visibleValue = this.fieldValue;
    }

    this.toggleValueVisibility();
  }

  public toggleValueVisibility() {
    this.valueVisible = this.selectedOperator.key === this.onKey;
    if (this.fieldValue === this.currentFieldValue) {
      this.fieldValue = '';
    }

    this.updateDbValue();
  }

  private updateDbValue() {
    if (this.selectedOperator.key === this.currentKey) {
      this.fieldValue = this.currentFieldValue;
    }
  }

  public get fieldId() {
    // replace all square brackets by underscore
    // to match the label's for value
    return this.fieldName
      .replace(/\[|\]/g, '_')
      .replace('__', '_')
      .replace(/_$/, '');
  }

  updateField(val:string) {
    this.fieldValue = val;
    this.cdRef.detectChanges();
  }
}
