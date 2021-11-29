

import { Component, Input, Output } from '@angular/core';
import { Instance } from 'flatpickr/dist/types/instance';
import { KeyCodes } from 'core-app/shared/helpers/keyCodes.enum';
import { DatePicker } from 'core-app/shared/components/op-date-picker/datepicker';
import { AbstractDatePickerDirective } from 'core-app/shared/components/op-date-picker/date-picker.directive';
import { DebouncedEventEmitter } from 'core-app/shared/helpers/rxjs/debounced-event-emitter';
import { componentDestroyed } from '@w11k/ngx-componentdestroyed';

@Component({
  selector: 'op-single-date-picker',
  templateUrl: './op-single-date-picker.component.html',
})
export class OpSingleDatePickerComponent extends AbstractDatePickerDirective {
  @Output() public changed = new DebouncedEventEmitter<string>(componentDestroyed(this));

  @Input() public initialDate = '';

  onInputChange():void {
    if (this.inputIsValidDate()) {
      this.changed.emit(this.currentValue);
    } else {
      this.changed.emit('');
    }
  }

  protected inputIsValidDate():boolean {
    return (/\d{4}-\d{2}-\d{2}/.exec(this.currentValue)) !== null;
  }

  protected initializeDatepicker():void {
    const options = {
      allowInput: true,
      appendTo: this.appendTo,
      onChange: (selectedDates:Date[], dateStr:string) => {
        const val:string = dateStr;

        if (this.isEmpty()) {
          return;
        }

        this.inputElement.value = val;
        this.changed.emit(val);
      },
      onKeyDown: (selectedDates:Date[], dateStr:string, instance:Instance, data:KeyboardEvent) => {
        if (data.which === KeyCodes.ESCAPE) {
          this.canceled.emit();
        }
      },
    };

    let initialValue;
    if (this.isEmpty() && this.initialDate) {
      initialValue = this.timezoneService.parseISODate(this.initialDate).toDate();
    } else {
      initialValue = this.currentValue;
    }

    this.datePickerInstance = new DatePicker(
      `#${this.id}`,
      initialValue,
      options,
      null,
      this.configurationService,
    );
  }
}
