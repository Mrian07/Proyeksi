

import { UserResource } from 'core-app/features/hal/resources/user-resource';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { PrincipalRendererService } from 'core-app/shared/components/principal/principal-renderer.service';
import { cssClassCustomOption } from 'core-app/shared/components/fields/display/display-field.module';
import { ResourcesDisplayField } from './resources-display-field.module';

export class MultipleUserFieldModule extends ResourcesDisplayField {
  @InjectField() principalRenderer:PrincipalRendererService;

  public render(element:HTMLElement, displayText:string):void {
    const names = this.value;
    element.innerHTML = '';
    element.setAttribute('title', names.join(', '));

    if (names.length === 0) {
      this.renderEmpty(element);
    } else {
      this.renderValues(this.attribute, element);
    }
  }

  /**
   * Renders at most the first two values, followed by a badge indicating
   * the total count.
   */
  protected renderValues(values:UserResource[], element:HTMLElement) {
    const content = document.createDocumentFragment();
    const divContainer = document.createElement('div');
    divContainer.classList.add(cssClassCustomOption);
    content.appendChild(divContainer);

    this.renderAbridgedValues(divContainer, values);

    if (values.length > 2) {
      const dots = document.createElement('span');
      dots.innerHTML = '... ';
      divContainer.appendChild(dots);

      const badge = this.optionDiv(values.length.toString(), 'badge', '-secondary');
      content.appendChild(badge);
    }

    element.appendChild(content);
  }

  public renderAbridgedValues(element:HTMLElement, values:UserResource[]) {
    const valueForDisplay = _.take(values, 2);
    this.principalRenderer.renderMultiple(
      element,
      valueForDisplay,
      { hide: false, link: false },
      { hide: false, size: 'medium' },
      false,
    );
  }
}
