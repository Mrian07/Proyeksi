

import { ChangeDetectionStrategy, Component } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { IfcModelsDataService } from 'core-app/features/bim/ifc_models/pages/viewer/ifc-models-data.service';

@Component({
  template: `
    <a *ngIf="manageAllowed"
       class="button"
       [href]="manageIFCPath">
      <op-icon icon-classes="button--icon icon-settings2"></op-icon>
      <span class="button--text"
            [textContent]="text.manage"
            aria-hidden="true"></span>
    </a>

  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'bim-view-toggle-button',
})
export class BimManageIfcModelsButtonComponent {
  text = {
    manage: this.I18n.t('js.ifc_models.models.ifc_models'),
  };

  manageAllowed = this.ifcData.allowed('manage_ifc_models');

  manageIFCPath = this.ifcData.manageIFCPath;

  constructor(readonly I18n:I18nService,
    readonly ifcData:IfcModelsDataService) {
  }
}
