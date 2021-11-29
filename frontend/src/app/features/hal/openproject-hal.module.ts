

import { APP_INITIALIZER, ErrorHandler, NgModule } from '@angular/core';
import { HTTP_INTERCEPTORS, HttpClientModule } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { OpenProjectHeaderInterceptor } from 'core-app/features/hal/http/openproject-header-interceptor';
import { HalAwareErrorHandler } from 'core-app/features/hal/services/hal-aware-error-handler';
import { initializeHalResourceConfig } from 'core-app/features/hal/services/hal-resource.config';
import { HalResourceService } from 'core-app/features/hal/services/hal-resource.service';
import { HalResourceNotificationService } from 'core-app/features/hal/services/hal-resource-notification.service';

@NgModule({
  imports: [
    CommonModule,
    HttpClientModule,
  ],
  providers: [
    { provide: ErrorHandler, useClass: HalAwareErrorHandler },
    { provide: HTTP_INTERCEPTORS, useClass: OpenProjectHeaderInterceptor, multi: true },
    {
      provide: APP_INITIALIZER, useFactory: initializeHalResourceConfig, deps: [HalResourceService], multi: true,
    },
    HalResourceNotificationService,
  ],
})
export class OpenprojectHalModule { }
