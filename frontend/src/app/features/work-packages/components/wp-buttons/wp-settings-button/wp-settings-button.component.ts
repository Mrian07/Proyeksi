

import { ChangeDetectionStrategy, Component } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';

@Component({
  templateUrl: './wp-settings-button.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class WorkPackageSettingsButtonComponent {
  public text = {
    button_settings: this.I18n.t('js.button_settings'),
  };

  constructor(readonly I18n:I18nService) {
  }
}
