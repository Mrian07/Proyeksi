

import { Component, OnDestroy, OnInit } from '@angular/core';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { take } from 'rxjs/operators';
import { DateEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/date-edit-field/date-edit-field.component';
import { OpModalComponent } from 'core-app/shared/components/modal/modal.component';
import { DatePickerModalComponent } from 'core-app/shared/components/datepicker/datepicker.modal';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';

@Component({
  template: `
    <input [value]="dates"
           (click)="handleClick()"
           class="op-input"
           type="text" />
  `,
})
export class CombinedDateEditFieldComponent extends DateEditFieldComponent implements OnInit, OnDestroy {
  @InjectField() readonly timezoneService:TimezoneService;

  @InjectField() opModalService:OpModalService;

  dates = '';

  text_no_start_date = this.I18n.t('js.label_no_start_date');

  text_no_due_date = this.I18n.t('js.label_no_due_date');

  private modal:OpModalComponent;

  ngOnInit() {
    super.ngOnInit();

    this.handler
      .$onUserActivate
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe(() => {
        this.showDatePickerModal();
      });
  }

  ngOnDestroy() {
    super.ngOnDestroy();
    this.modal?.closeMe();
  }

  public handleClick() {
    this.showDatePickerModal();
  }

  private showDatePickerModal():void {
    const modal = this.modal = this
      .opModalService
      .show(DatePickerModalComponent, this.injector, { changeset: this.change, fieldName: this.name }, true);

    setTimeout(() => {
      const modalElement = jQuery(modal.elementRef.nativeElement).find('.datepicker-modal');
      const field = jQuery(this.elementRef.nativeElement);
      modal.reposition(modalElement, field);
    });

    modal
      .onDataUpdated
      .subscribe((dates:string) => {
        this.dates = dates;
        this.cdRef.detectChanges();
      });

    modal
      .closingEvent
      .pipe(take(1))
      .subscribe(() => {
        this.handler.handleUserSubmit();
      });
  }

  // Overwrite super in order to set the inital dates.
  protected initialize() {
    super.initialize();

    // this breaks the preceived abstraction of the edit fields. But the date picker
    // is already highly specific to start and due Date.
    this.dates = `${this.currentStartDate} - ${this.currentDueDate}`;
  }

  protected get currentStartDate():string {
    return this.resource.startDate || this.text_no_start_date;
  }

  protected get currentDueDate():string {
    return this.resource.dueDate || this.text_no_due_date;
  }
}
