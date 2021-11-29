

import { cssClassCustomOption, DisplayField } from 'core-app/shared/components/fields/display/display-field.module';

export class ResourcesDisplayField extends DisplayField {
  public isEmpty():boolean {
    return _.isEmpty(this.value);
  }

  public get value() {
    const cf = this.resource[this.name];
    if (this.schema && cf) {
      if (cf.elements) {
        return cf.elements.map((e:any) => e.name);
      } if (cf.map) {
        return cf.map((e:any) => e.name);
      } if (cf.name) {
        return [cf.name];
      }
      return [`error: ${JSON.stringify(cf)}`];
    }

    return [];
  }

  public render(element:HTMLElement, displayText:string):void {
    const values = this.value;
    element.innerHTML = '';
    element.setAttribute('title', values.join(', '));

    if (values.length === 0) {
      this.renderEmpty(element);
    } else {
      this.renderValues(values, element);
    }
  }

  /**
   * Renders at most the first two values, followed by a badge indicating
   * the total count.
   */
  protected renderValues(values:any[], element:HTMLElement) {
    const content = document.createDocumentFragment();
    const abridged = this.optionDiv(this.valueAbridged(values));

    content.appendChild(abridged);

    if (values.length > 2) {
      const badge = this.optionDiv(values.length.toString(), 'badge', '-secondary');
      content.appendChild(badge);
    }

    element.appendChild(content);
  }

  /**
   * Build .custom-option div/span nodes with the given text
   */
  protected optionDiv(text:string, ...classes:string[]) {
    const div = document.createElement('div');
    const span = document.createElement('span');
    div.classList.add(cssClassCustomOption);
    span.classList.add(...classes);
    span.textContent = text;

    div.appendChild(span);

    return div;
  }

  /**
   * Return the first two joined values, if any.
   */
  protected valueAbridged(values:any[]) {
    const valueForDisplay = _.take(values, 2);

    if (values.length > 2) {
      valueForDisplay.push('... ');
    }

    return valueForDisplay.join(', ');
  }
}
