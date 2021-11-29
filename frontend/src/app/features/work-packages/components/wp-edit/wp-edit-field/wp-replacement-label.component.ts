

import {
  Component, ElementRef, Input, OnInit,
} from '@angular/core';
import { EditFormComponent } from 'core-app/shared/components/fields/edit/edit-form/edit-form.component';

@Component({
  selector: 'wp-replacement-label',
  templateUrl: './wp-replacement-label.html',
})
export class WorkPackageReplacementLabelComponent implements OnInit {
  @Input('fieldName') public fieldName:string;

  private $element:JQuery;

  constructor(protected wpeditForm:EditFormComponent,
    protected elementRef:ElementRef) {
  }

  ngOnInit() {
    this.$element = jQuery(this.elementRef.nativeElement);
  }

  public activate(evt:JQuery.TriggeredEvent) {
    // Skip clicks on help texts
    const target = jQuery(evt.target);
    if (target.closest('.help-text--entry').length) {
      return true;
    }

    const field = this.wpeditForm.fields[this.fieldName];
    field && field.handleUserActivate(null);

    return false;
  }
}
