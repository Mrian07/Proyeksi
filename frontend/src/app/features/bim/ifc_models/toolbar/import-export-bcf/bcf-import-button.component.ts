

import { Component } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';
import { BcfPathHelperService } from 'core-app/features/bim/bcf/helper/bcf-path-helper.service';

@Component({
  template: `
    <a [title]="text.import_hover"
      (click)="handleClick()"
      class="button import-bcf-button">
      <op-icon icon-classes="button--icon icon-import"></op-icon>
      <span class="button--text"> {{text.import}} </span>
    </a>
  `,
  selector: 'bcf-import-button',
})
export class BcfImportButtonComponent {
  public text = {
    import: this.I18n.t('js.bcf.import'),
    import_hover: this.I18n.t('js.bcf.import_bcf_xml_file'),
  };

  constructor(readonly I18n:I18nService,
    readonly currentProject:CurrentProjectService,
    readonly bcfPathHelper:BcfPathHelperService) {
  }

  public handleClick() {
    const projectIdentifier = this.currentProject.identifier;
    if (projectIdentifier) {
      const url = this.bcfPathHelper.projectImportIssuePath(projectIdentifier);
      window.location.href = url;
    }
  }
}
