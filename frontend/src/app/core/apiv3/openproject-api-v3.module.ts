

import { OPSharedModule } from 'core-app/shared/shared.module';
import { NgModule } from '@angular/core';
import { OpenprojectHalModule } from 'core-app/features/hal/openproject-hal.module';

@NgModule({
  imports: [
    // Commons
    OPSharedModule,
    OpenprojectHalModule,
  ],
})
export class OpenprojectApiV3Module {
}
