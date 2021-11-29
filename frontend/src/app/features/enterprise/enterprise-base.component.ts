

import { Component, Injector } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { EnterpriseTrialModalComponent } from 'core-app/features/enterprise/enterprise-modal/enterprise-trial.modal';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { EnterpriseTrialService } from 'core-app/features/enterprise/enterprise-trial.service';

export const enterpriseBaseSelector = 'enterprise-base';

@Component({
  selector: enterpriseBaseSelector,
  templateUrl: './enterprise-base.component.html',
  styleUrls: ['./enterprise-base.component.sass'],
})
export class EnterpriseBaseComponent {
  public text = {
    button_trial: this.I18n.t('js.admin.enterprise.upsale.button_start_trial'),
    button_book: this.I18n.t('js.admin.enterprise.upsale.button_book_now'),
    link_quote: this.I18n.t('js.admin.enterprise.upsale.link_quote'),
    become_hero: this.I18n.t('js.admin.enterprise.upsale.become_hero'),
    you_contribute: this.I18n.t('js.admin.enterprise.upsale.you_contribute'),
    email_not_received: this.I18n.t('js.admin.enterprise.trial.email_not_received'),
    enterprise_edition: this.I18n.t('js.admin.enterprise.upsale.text'),
    confidence: this.I18n.t('js.admin.enterprise.upsale.confidence'),
    try_another_email: this.I18n.t('js.admin.enterprise.trial.try_another_email'),
  };

  constructor(protected I18n:I18nService,
    protected opModalService:OpModalService,
    readonly injector:Injector,
    public eeTrialService:EnterpriseTrialService) {
  }

  public openTrialModal() {
    // cancel request and open first modal window
    this.eeTrialService.cancelled = true;
    this.eeTrialService.modalOpen = true;
    this.opModalService.show(EnterpriseTrialModalComponent, this.injector);
  }

  public get noTrialRequested() {
    return this.eeTrialService.status === undefined;
  }
}
