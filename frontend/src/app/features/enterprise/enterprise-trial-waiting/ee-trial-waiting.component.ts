

import { Component, ElementRef, OnInit } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { EnterpriseTrialService } from 'core-app/features/enterprise/enterprise-trial.service';
import { HttpClient } from '@angular/common/http';
import { ToastService } from 'core-app/shared/components/toaster/toast.service';
import { distinctUntilChanged } from 'rxjs/operators';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';

@Component({
  selector: 'enterprise-trial-waiting',
  templateUrl: './ee-trial-waiting.component.html',
  styleUrls: ['./ee-trial-waiting.component.sass'],
})
export class EETrialWaitingComponent implements OnInit {
  created = this.timezoneService.formattedDate(new Date().toString());

  email = '';

  public text = {
    confirmation_info: (date:string, email:string) => this.I18n.t('js.admin.enterprise.trial.confirmation_info', {
      date,
      email,
    }),
    resend: this.I18n.t('js.admin.enterprise.trial.resend_link'),
    resend_success: this.I18n.t('js.admin.enterprise.trial.resend_success'),
    resend_warning: this.I18n.t('js.admin.enterprise.trial.resend_warning'),
    session_timeout: this.I18n.t('js.admin.enterprise.trial.session_timeout'),
    status_confirmed: this.I18n.t('js.admin.enterprise.trial.status_confirmed'),
    status_label: this.I18n.t('js.admin.enterprise.trial.status_label'),
    status_waiting: this.I18n.t('js.admin.enterprise.trial.status_waiting'),
  };

  constructor(readonly elementRef:ElementRef,
    readonly I18n:I18nService,
    protected http:HttpClient,
    protected toastService:ToastService,
    public eeTrialService:EnterpriseTrialService,
    readonly timezoneService:TimezoneService) {
  }

  ngOnInit() {
    const eeTrialKey = (window as any).gon.ee_trial_key;
    if (eeTrialKey) {
      const savedDateStr = eeTrialKey.created.split(' ')[0];
      this.created = this.timezoneService.formattedDate(savedDateStr);
    }

    this.eeTrialService.userData$
      .values$()
      .pipe(
        distinctUntilChanged(),
      )
      .subscribe((userForm) => {
        this.email = userForm.email;
      });
  }

  // resend mail if resend link has been clicked
  public resendMail() {
    this.eeTrialService.cancelled = false;
    this.http.post(this.eeTrialService.resendLink, {})
      .toPromise()
      .then(() => {
        this.toastService.addSuccess(this.text.resend_success);
        this.eeTrialService.retryConfirmation();
      })
      .catch(() => {
        if (this.eeTrialService.trialLink) {
          // Check whether the mail has been confirmed by now
          this.eeTrialService.getToken();
        } else {
          this.toastService.addError(this.text.resend_warning);
        }
      });
  }
}
