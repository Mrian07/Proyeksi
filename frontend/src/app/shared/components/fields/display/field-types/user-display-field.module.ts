

import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { PrincipalRendererService } from 'core-app/shared/components/principal/principal-renderer.service';

export class UserDisplayField extends DisplayField {
  @InjectField() principalRenderer:PrincipalRendererService;

  public get value() {
    if (this.schema) {
      return this.attribute && this.attribute.name;
    }
    return null;
  }

  public render(element:HTMLElement, displayText:string):void {
    if (this.placeholder === displayText) {
      this.renderEmpty(element);
    } else {
      this.principalRenderer.render(
        element,
        this.attribute,
        { hide: false, link: false },
        { hide: false, size: 'medium' },
      );
    }
  }
}
