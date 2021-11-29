

import { ChangeDetectionStrategy, Component } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { BimViewService } from 'core-app/features/bim/ifc_models/pages/viewer/bim-view.service';

@Component({
  template: `
    <ng-container *ngIf="(view$ | async) as current">
      <button class="button"
              id="bim-view-toggle-button"
              bimViewDropdown>
        <op-icon icon-classes="button--icon {{bimView.icon[current]}}"></op-icon>
        <span class="button--text"
              aria-hidden="true"
              [textContent]="bimView.text[current]">
        </span>
        <op-icon icon-classes="button--icon icon-small icon-pulldown"></op-icon>
      </button>
    </ng-container>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'bim-view-toggle-button',
})
export class BimViewToggleButtonComponent {
  view$ = this.bimView.view$;

  constructor(readonly I18n:I18nService,
    readonly bimView:BimViewService) {
  }
}
