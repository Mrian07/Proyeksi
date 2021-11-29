

import { ChangeDetectionStrategy, Component, ElementRef } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { EEActiveTrialBase } from 'core-app/features/enterprise/enterprise-active-trial/ee-active-trial.base';

export const enterpriseActiveSavedTrialSelector = 'enterprise-active-saved-trial';

@Component({
  selector: enterpriseActiveSavedTrialSelector,
  templateUrl: './ee-active-trial.component.html',
  styleUrls: ['./ee-active-trial.component.sass'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class EEActiveSavedTrialComponent extends EEActiveTrialBase {
  public subscriber = this.elementRef.nativeElement.dataset.subscriber;

  public email = this.elementRef.nativeElement.dataset.email;

  public company = this.elementRef.nativeElement.dataset.company;

  public domain = this.elementRef.nativeElement.dataset.domain;

  public userCount = this.elementRef.nativeElement.dataset.userCount;

  public startsAt = this.elementRef.nativeElement.dataset.startsAt;

  public expiresAt = this.elementRef.nativeElement.dataset.expiresAt;

  public isExpired:boolean = this.elementRef.nativeElement.dataset.isExpired === 'true';

  public reprieveDaysLeft = this.elementRef.nativeElement.dataset.reprieveDaysLeft;

  constructor(readonly elementRef:ElementRef,
    readonly I18n:I18nService) {
    super(I18n);
  }

  public get expiredWarningText():string {
    let warning = this.text.text_expired;

    if (this.reprieveDaysLeft && this.reprieveDaysLeft > 0) {
      warning = `${warning}: ${this.text.text_reprieve_days_left(this.reprieveDaysLeft)}`;
    }

    return warning;
  }
}
