

import { NgModule } from '@angular/core';
import { UIRouterModule } from '@uirouter/angular';
import { WORK_PACKAGES_ROUTES } from 'core-app/features/work-packages/routing/work-packages-routes';
import { OpenprojectWorkPackagesModule } from 'core-app/features/work-packages/openproject-work-packages.module';

/**
 * Separate module for work package routes because WP modules
 * are required by other lazy-loaded modules such as calendar.
 *
 * And we must not re-import a module with route definitions.
 */

@NgModule({
  imports: [
    // Import the actual WP modules
    OpenprojectWorkPackagesModule,

    // Routes for /work_packages
    UIRouterModule.forChild({ states: WORK_PACKAGES_ROUTES }),
  ],
})
export class OpenprojectWorkPackageRoutesModule {
}
