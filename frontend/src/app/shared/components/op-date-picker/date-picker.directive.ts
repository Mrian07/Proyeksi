

import {
  AfterViewInit,
  Directive,
  ElementRef,
  EventEmitter,
  Input,
  OnDestroy,
  Output,
  ViewChild,
} from '@angular/core';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';
import { DatePicker } from 'core-app/shared/components/op-date-picker/datepicker';
import { ConfigurationService } from 'core-app/core/config/configuration.service';

@Directive()
export abstract class AbstractDatePickerDirective extends UntilDestroyedMixin implements OnDestroy, AfterViewInit {
  @Output() public canceled = new EventEmitter<string>();

  @Input() public appendTo?:HTMLElement;

  @Input() public classes = '';

  @Input() public id = '';

  @Input() public name = '';

  @Input() public required = false;

  @Input() public size = 20;

  @Input() public disabled = false;

  @ViewChild('dateInput') dateInput:ElementRef;

  protected datePickerInstance:DatePicker;

  public constructor(
    protected timezoneService:TimezoneService,
    protected configurationService:ConfigurationService,
  ) {
    super();

    if (!this.id) {
      this.id = `datepicker-input-${Math.floor(Math.random() * 1000).toString(3)}`;
    }
  }

  ngAfterViewInit():void {
    this.initializeDatepicker();
  }

  ngOnDestroy():void {
    if (this.datePickerInstance) {
      this.datePickerInstance.destroy();
    }
  }

  openOnClick():void {
    if (!this.disabled) {
      this.datePickerInstance.show();
    }
  }

  closeOnOutsideClick(event:any):void {
    if (!(event.relatedTarget
      && this.datePickerInstance.datepickerInstance.calendarContainer.contains(event.relatedTarget))) {
      this.close();
    }
  }

  close():void {
    this.datePickerInstance.hide();
  }

  protected isEmpty():boolean {
    return this.currentValue.trim() === '';
  }

  protected get currentValue():string {
    return this.inputElement?.value || '';
  }

  protected get inputElement():HTMLInputElement {
    return this.dateInput?.nativeElement;
  }

  protected abstract initializeDatepicker():void;
}
