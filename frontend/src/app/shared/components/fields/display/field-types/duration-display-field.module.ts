

import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';

export class DurationDisplayField extends DisplayField {
  @InjectField() timezoneService:TimezoneService;

  private derivedText = this.I18n.t('js.label_value_derived_from_children');

  public get valueString() {
    return this.timezoneService.formattedDuration(this.value);
  }

  /**
   * Duration fields may have an additional derived value
   */
  public get derivedPropertyName() {
    return `derived${this.name.charAt(0).toUpperCase()}${this.name.slice(1)}`;
  }

  public get derivedValue():string|null {
    return this.resource[this.derivedPropertyName];
  }

  public get derivedValueString():string {
    const value = this.derivedValue;

    if (value) {
      return this.timezoneService.formattedDuration(value);
    }
    return this.placeholder;
  }

  public render(element:HTMLElement, displayText:string):void {
    if (this.isEmpty()) {
      element.textContent = this.placeholder;
      return;
    }

    element.classList.add('split-time-field');
    const { value } = this;
    const actual:number = (value && this.timezoneService.toHours(value)) || 0;

    if (actual !== 0) {
      this.renderActual(element, displayText);
    }

    const derived = this.derivedValue;
    if (derived && this.timezoneService.toHours(derived) !== 0) {
      this.renderDerived(element, this.derivedValueString, actual !== 0);
    }
  }

  public renderActual(element:HTMLElement, displayText:string):void {
    const span = document.createElement('span');

    span.textContent = displayText;
    span.title = this.valueString;
    span.classList.add('-actual-value');

    element.appendChild(span);
  }

  public renderDerived(element:HTMLElement, displayText:string, actualPresent:boolean):void {
    const span = document.createElement('span');

    span.setAttribute('title', this.texts.empty);
    span.textContent = `(${actualPresent ? '+' : ''}${displayText})`;
    span.title = `${this.derivedValueString} ${this.derivedText}`;
    span.classList.add('-derived-value');

    if (actualPresent) {
      span.classList.add('-with-actual-value');
    }

    element.appendChild(span);
  }

  public get title():string|null {
    return null; // we want to render separate titles ourselves
  }

  public isEmpty():boolean {
    const { value } = this;
    const derived = this.derivedValue;

    const valueEmpty = !value || this.timezoneService.toHours(value) === 0;
    const derivedEmpty = !derived || this.timezoneService.toHours(derived) === 0;

    return valueEmpty && derivedEmpty;
  }
}
