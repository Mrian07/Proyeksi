

import { ProgressDisplayField } from './progress-display-field.module';

export class ProgressTextDisplayField extends ProgressDisplayField {
  public render(element:HTMLElement, displayText:string):void {
    const label = this.percentLabel;
    element.setAttribute('title', label);
    element.innerHTML = '';
    element.textContent = label;
  }
}
