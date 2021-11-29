

import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';
import {
  projectStatusCodeCssClass,
  projectStatusI18n,
} from 'core-app/shared/components/fields/helpers/project-status-helper';

export class ProjectStatusDisplayField extends DisplayField {
  public render(element:HTMLElement, displayText:string):void {
    const code = this.value && this.value.id;

    const bulb = document.createElement('span');
    bulb.classList.add('project-status--bulb', projectStatusCodeCssClass(code));

    const name = document.createElement('span');
    name.classList.add('project-status--name', projectStatusCodeCssClass(code));
    name.textContent = projectStatusI18n(code, this.I18n);

    element.innerHTML = '';
    element.appendChild(bulb);
    element.appendChild(name);

    if (this.writable) {
      const pulldown = document.createElement('span');
      pulldown.classList.add('project-status--pulldown-icon', 'icon', 'icon-pulldown');

      element.appendChild(pulldown);
    }
  }
}
