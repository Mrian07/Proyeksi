

import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { I18nService } from 'core-app/core/i18n/i18n.service';

export class EEActiveTrialBase extends UntilDestroyedMixin {
  public text = {
    label_email: this.I18n.t('js.label_email'),
    label_expires_at: this.I18n.t('js.admin.enterprise.trial.form.label_expires_at'),
    label_maximum_users: this.I18n.t('js.admin.enterprise.trial.form.label_maximum_users'),
    label_company: this.I18n.t('js.admin.enterprise.trial.form.label_company'),
    label_domain: this.I18n.t('js.admin.enterprise.trial.form.label_domain'),
    label_starts_at: this.I18n.t('js.admin.enterprise.trial.form.label_starts_at'),
    label_subscriber: this.I18n.t('js.admin.enterprise.trial.form.label_subscriber'),
    text_expired: this.I18n.t('js.admin.enterprise.text_expired'),
    text_reprieve_days_left: (days:number) => this.I18n.t('js.admin.enterprise.text_reprieve_days_left', { days }),
  };

  constructor(readonly I18n:I18nService) {
    super();
  }
}
