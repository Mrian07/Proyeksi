

import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';

export class ProgressDisplayField extends DisplayField {
  public get value() {
    if (this.schema) {
      return this.resource[this.name] || 0;
    }
    return null;
  }

  public get percentLabel() {
    return `${this.roundedProgress}%`;
  }

  public get roundedProgress() {
    return Math.round(Number(this.value)) || 0;
  }

  public render(element:HTMLElement, displayText:string):void {
    element.setAttribute('title', displayText);
    element.innerHTML = `
      <span>
        <span style="width: 80px" class="progress-bar">
          <span style="width: ${this.roundedProgress}%" class="inner-progress closed"></span>
          <span style="width: 0%" class="inner-progress done"></span>
        </span>
        <span class="progress-bar-legend">${this.percentLabel}</span>
      </span>
    `;
  }
}
