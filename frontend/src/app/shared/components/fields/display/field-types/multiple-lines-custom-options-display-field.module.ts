

import { cssClassCustomOption } from 'core-app/shared/components/fields/display/display-field.module';
import { ResourcesDisplayField } from './resources-display-field.module';

export class MultipleLinesCustomOptionsDisplayField extends ResourcesDisplayField {
  public render(element:HTMLElement, displayText:string):void {
    const values = this.value;
    element.setAttribute('title', displayText);
    element.textContent = displayText;

    element.innerHTML = '';

    if (values.length === 0) {
      this.renderEmpty(element);
    } else {
      this.renderValues(values, element);
    }
  }

  protected renderValues(values:string[], element:HTMLElement) {
    values.forEach((value) => {
      const div = document.createElement('div');
      div.classList.add(cssClassCustomOption, '-multiple-lines');
      div.setAttribute('title', value);
      div.textContent = value;

      element.appendChild(div);
    });
  }
}
