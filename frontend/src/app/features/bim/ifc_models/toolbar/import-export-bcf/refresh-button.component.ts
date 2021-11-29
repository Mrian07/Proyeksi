

import { ChangeDetectionStrategy, Component } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { StateService } from '@uirouter/core';

@Component({
  template: `
    <a [title]="text.refresh_hover"
       class="button refresh-button"
       (click)="refresh()">
      <op-icon icon-classes="button--icon icon-workflow"></op-icon>
    </a>
  `,
  selector: 'op-refresh-button',
  changeDetection: ChangeDetectionStrategy.OnPush,
})

export class RefreshButtonComponent {
  public text = {
    refresh: this.I18n.t('js.bcf.refresh'),
    refresh_hover: this.I18n.t('js.bcf.refresh_work_package'),
  };

  constructor(readonly I18n:I18nService,
    readonly state:StateService) {
  }

  refresh() {
    void this.state.go('.', {}, { reload: true });
  }
}
