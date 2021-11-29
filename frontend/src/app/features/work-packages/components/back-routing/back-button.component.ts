

import { ChangeDetectionStrategy, Component, Input } from '@angular/core';
import { BackRoutingService } from 'core-app/features/work-packages/components/back-routing/back-routing.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';

@Component({
  templateUrl: './back-button.component.html',
  styleUrls: ['./back-button.component.sass'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'op-back-button',
})
export class BackButtonComponent {
  @Input() public linkClass:string;

  @Input() public customBackMethod:() => unknown;

  public text = {
    goBack: this.I18n.t('js.button_back'),
  };

  constructor(readonly backRoutingService:BackRoutingService,
    readonly I18n:I18nService) {
  }

  public goBack():void {
    if (this.customBackMethod) {
      this.customBackMethod();
    } else {
      this.backRoutingService.goBack();
    }
  }
}
