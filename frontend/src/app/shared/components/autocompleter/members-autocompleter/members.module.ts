

import { NgModule } from '@angular/core';
import { MembersAutocompleterComponent } from 'core-app/shared/components/autocompleter/members-autocompleter/members-autocompleter.component';
import { NgSelectModule } from '@ng-select/ng-select';
import { OPSharedModule } from 'core-app/shared/shared.module';

@NgModule({
  imports: [
    OPSharedModule,
    NgSelectModule,
  ],
  exports: [],
  declarations: [
    MembersAutocompleterComponent,
  ],
})
export class OpenprojectMembersModule { }
