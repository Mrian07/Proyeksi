

import { Component, Input } from '@angular/core';
import { WorkPackageResource } from "core-app/features/hal/resources/work-package-resource";
import { I18nService } from "core-app/core/i18n/i18n.service";

@Component({
  selector: 'tab-header',
  templateUrl: './tab-header.template.html',
  styleUrls: [
    './styles/tab-header.sass'
  ]
})
export class TabHeaderComponent {
  @Input() public workPackage:WorkPackageResource;

  public text = {
    title: this.I18n.t('js.github_integration.tab_header.title'),
    createPrButtonLabel: this.I18n.t('js.github_integration.tab_header.create_pr.label'),
    createPrButtonDescription: this.I18n.t('js.github_integration.tab_header.create_pr.description'),
    gitMenuLabel: this.I18n.t('js.github_integration.tab_header.copy_menu.label'),
    gitMenuDescription: this.I18n.t('js.github_integration.tab_header.copy_menu.description'),
  };

  constructor(readonly I18n:I18nService) {
  }
}
