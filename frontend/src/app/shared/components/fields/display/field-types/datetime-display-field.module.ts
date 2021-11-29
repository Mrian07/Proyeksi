

import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';

export class DateTimeDisplayField extends DisplayField {
  @InjectField() timezoneService:TimezoneService;

  public get valueString() {
    if (this.value) {
      return this.timezoneService.formattedDatetime(this.value);
    }

    return '';
  }
}
