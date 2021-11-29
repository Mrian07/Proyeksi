

import { NgModule } from '@angular/core';
import { OpenprojectBcfModule } from 'core-app/features/bim/bcf/openproject-bcf.module';
import { OpenprojectIFCModelsModule } from 'core-app/features/bim/ifc_models/openproject-ifc-models.module';

@NgModule({
  imports: [
    OpenprojectBcfModule,
    OpenprojectIFCModelsModule,
  ],
})
export class OpenprojectBimModule {
}
