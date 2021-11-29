

import { UserResource } from 'core-app/features/hal/resources/user-resource';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { PrincipalRendererService } from 'core-app/shared/components/principal/principal-renderer.service';
import { ResourcesDisplayField } from './resources-display-field.module';

export class MultipleLinesUserFieldModule extends ResourcesDisplayField {
  @InjectField() principalRenderer:PrincipalRendererService;

  public render(element:HTMLElement, displayText:string):void {
    const values = this.attribute;
    element.setAttribute('title', displayText);
    element.textContent = displayText;

    element.innerHTML = '';

    if (values.length === 0) {
      this.renderEmpty(element);
    } else {
      this.renderValues(values, element);
    }
  }

  protected renderValues(values:UserResource[], element:HTMLElement) {
    this.principalRenderer.renderMultiple(
      element,
      values,
      { hide: false, link: false },
      { hide: false, size: 'medium' },
      true,
    );
  }
}
