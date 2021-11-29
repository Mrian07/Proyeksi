

import { NgModule } from '@angular/core';
import { OPSharedModule } from 'core-app/shared/shared.module';
import { OpenprojectModalModule } from 'core-app/shared/components/modal/modal.module';
import { EnterpriseTrialService } from 'core-app/features/enterprise/enterprise-trial.service';
import { EnterpriseBaseComponent } from 'core-app/features/enterprise/enterprise-base.component';
import { EnterpriseTrialModalComponent } from 'core-app/features/enterprise/enterprise-modal/enterprise-trial.modal';
import { EETrialFormComponent } from 'core-app/features/enterprise/enterprise-modal/enterprise-trial-form/ee-trial-form.component';
import { EETrialWaitingComponent } from 'core-app/features/enterprise/enterprise-trial-waiting/ee-trial-waiting.component';
import { EEActiveTrialComponent } from 'core-app/features/enterprise/enterprise-active-trial/ee-active-trial.component';
import { EEActiveSavedTrialComponent } from 'core-app/features/enterprise/enterprise-active-trial/ee-active-saved-trial.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

@NgModule({
  imports: [
    OPSharedModule,
    OpenprojectModalModule,
    FormsModule,
    ReactiveFormsModule,
  ],
  providers: [
    EnterpriseTrialService,
  ],
  declarations: [
    EnterpriseBaseComponent,
    EnterpriseTrialModalComponent,
    EETrialFormComponent,
    EETrialWaitingComponent,
    EEActiveTrialComponent,
    EEActiveSavedTrialComponent,
  ],
})
export class OpenprojectEnterpriseModule {
}
