

import { Highlighting } from 'core-app/features/work-packages/components/wp-fast-table/builders/highlighting/highlighting.functions';
import { HighlightableDisplayField } from 'core-app/shared/components/fields/display/field-types/highlightable-display-field.module';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';

export class DateDisplayField extends HighlightableDisplayField {
  @InjectField() timezoneService:TimezoneService;

  @InjectField() apiV3Service:APIV3Service;

  public render(element:HTMLElement, displayText:string):void {
    super.render(element, displayText);

    // Show scheduling mode in front of the start date field
    if (this.showSchedulingMode()) {
      const schedulingIcon = document.createElement('span');
      schedulingIcon.classList.add('icon-context');

      if (this.resource.scheduleManually) {
        schedulingIcon.classList.add('icon-pin');
      }

      element.prepend(schedulingIcon);
    }

    // Highlight overdue tasks
    if (this.shouldHighlight && this.canOverdue) {
      const diff = this.timezoneService.daysFromToday(this.value);

      this
        .apiV3Service
        .statuses
        .id(this.resource.status.id)
        .get()
        .toPromise()
        .then((status) => {
          if (!status.isClosed) {
            element.classList.add(Highlighting.overdueDate(diff));
          }
        });
    }
  }

  public get canOverdue():boolean {
    return ['dueDate', 'date'].indexOf(this.name) !== -1;
  }

  public get valueString() {
    if (this.value) {
      return this.timezoneService.formattedDate(this.value);
    }
    return '';
  }

  private showSchedulingMode():boolean {
    return this.name === 'startDate' || this.name === 'date';
  }
}
