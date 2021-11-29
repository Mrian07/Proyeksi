

import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { BcfPathHelperService } from 'core-app/features/bim/bcf/helper/bcf-path-helper.service';

export class BcfThumbnailDisplayField extends DisplayField {
  @InjectField() bcfPathHelper:BcfPathHelperService;

  public render(element:HTMLElement, displayText:string):void {
    const viewpoints = this.resource.bcfViewpoints;
    if (viewpoints && viewpoints.length > 0) {
      const viewpoint = viewpoints[0];
      element.innerHTML = `
        <img src="${this.bcfPathHelper.snapshotPath(viewpoint)}" class="thumbnail">
      `;
    } else {
      element.innerHTML = '';
    }
  }
}
