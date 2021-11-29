

import { DateDisplayField } from 'core-app/shared/components/fields/display/field-types/date-display-field.module';

export class CombinedDateDisplayField extends DateDisplayField {
  text = {
    placeholder: {
      startDate: this.I18n.t('js.label_no_start_date'),
      dueDate: this.I18n.t('js.label_no_due_date'),
    },
  };

  public render(element:HTMLElement, displayText:string):void {
    element.innerHTML = '';

    const startDateElement = this.createDateDisplayField('startDate');
    const dueDateElement = this.createDateDisplayField('dueDate');

    const separator = document.createElement('span');
    separator.textContent = ' - ';

    element.appendChild(startDateElement);
    element.appendChild(separator);
    element.appendChild(dueDateElement);
  }

  private createDateDisplayField(date:'dueDate'|'startDate'):HTMLElement {
    const dateElement = document.createElement('span');
    const dateDisplayField = new DateDisplayField(date, this.context);
    const text = this.resource[date]
      ? this.timezoneService.formattedDate(this.resource[date])
      : this.text.placeholder[date];

    dateDisplayField.apply(this.resource, this.schema);
    dateDisplayField.render(dateElement, text);

    return dateElement;
  }
}
