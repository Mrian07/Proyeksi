

import {
  ChangeDetectorRef, Component, ElementRef, OnInit,
} from '@angular/core';
import { distinctUntilChanged } from 'rxjs/operators';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { EnterpriseTrialService } from 'core-app/features/enterprise/enterprise-trial.service';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { EEActiveTrialBase } from 'core-app/features/enterprise/enterprise-active-trial/ee-active-trial.base';
import { GonService } from 'core-app/core/gon/gon.service';

@Component({
  selector: 'enterprise-active-trial',
  templateUrl: './ee-active-trial.component.html',
  styleUrls: ['./ee-active-trial.component.sass'],
})
export class EEActiveTrialComponent extends EEActiveTrialBase implements OnInit {
  public subscriber:string;

  public email:string;

  public company:string;

  public domain:string;

  public userCount:string;

  public startsAt:string;

  public expiresAt:string;

  constructor(readonly elementRef:ElementRef,
    readonly cdRef:ChangeDetectorRef,
    readonly I18n:I18nService,
    readonly http:HttpClient,
    readonly Gon:GonService,
    public eeTrialService:EnterpriseTrialService) {
    super(I18n);
  }

  ngOnInit() {
    if (!this.subscriber) {
      this.eeTrialService.userData$
        .values$()
        .pipe(
          distinctUntilChanged(),
          this.untilDestroyed(),
        )
        .subscribe((userForm) => {
          this.formatUserData(userForm);
          this.cdRef.detectChanges();
        });

      this.initialize();
    }
  }

  private initialize():void {
    const eeTrialKey = this.Gon.get('ee_trial_key') as any;

    if (eeTrialKey && !this.eeTrialService.userData$.hasValue()) {
      // after reload: get data from Augur using the trial key saved in gon
      this.eeTrialService.trialLink = `${this.eeTrialService.baseUrlAugur}/public/v1/trials/${eeTrialKey.value}`;
      this.getUserDataFromAugur();
    }
  }

  // use the trial key saved in the db
  // to get the user data from Augur
  private getUserDataFromAugur() {
    this.http
      .get<any>(`${this.eeTrialService.trialLink}/details`)
      .toPromise()
      .then((userForm:any) => {
        this.eeTrialService.userData$.putValue(userForm);
        this.eeTrialService.retryConfirmation();
      })
      .catch((error:HttpErrorResponse) => {
        // Check whether the mail has been confirmed by now
        this.eeTrialService.getToken();
      });
  }

  private formatUserData(userForm:any) {
    this.subscriber = `${userForm.first_name} ${userForm.last_name}`;
    this.email = userForm.email;
    this.company = userForm.company;
    this.domain = userForm.domain;
  }
}
