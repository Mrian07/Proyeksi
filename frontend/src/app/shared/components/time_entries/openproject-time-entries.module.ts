

import { NgModule } from '@angular/core';
import { OPSharedModule } from 'core-app/shared/shared.module';
import { OpenprojectModalModule } from 'core-app/shared/components/modal/modal.module';
import { OpenprojectFieldsModule } from 'core-app/shared/components/fields/openproject-fields.module';
import { TimeEntryCreateModalComponent } from 'core-app/shared/components/time_entries/create/create.modal';
import { TimeEntryEditModalComponent } from 'core-app/shared/components/time_entries/edit/edit.modal';
import { TimeEntryFormComponent } from 'core-app/shared/components/time_entries/form/form.component';
import { TimeEntryEditService } from 'core-app/shared/components/time_entries/edit/edit.service';
import { TriggerActionsEntryComponent } from 'core-app/shared/components/time_entries/edit/trigger-actions-entry.component';

@NgModule({
  imports: [
    // Commons
    OPSharedModule,
    OpenprojectModalModule,

    // Editable fields e.g. for modals
    OpenprojectFieldsModule,
  ],
  providers: [
    TimeEntryEditService,
  ],
  declarations: [
    TimeEntryEditModalComponent,
    TimeEntryCreateModalComponent,
    TimeEntryFormComponent,
    TriggerActionsEntryComponent,
  ],
})
export class OpenprojectTimeEntriesModule {
}
