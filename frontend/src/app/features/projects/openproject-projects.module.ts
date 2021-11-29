

import { NgModule } from '@angular/core';
import { OpenprojectHalModule } from 'core-app/features/hal/openproject-hal.module';
import { UIRouterModule } from '@uirouter/angular';
import { OpenprojectFieldsModule } from 'core-app/shared/components/fields/openproject-fields.module';
import { PROJECTS_ROUTES, uiRouterProjectsConfiguration } from 'core-app/features/projects/projects-routes';
import { DynamicFormsModule } from 'core-app/shared/components/dynamic-forms/dynamic-forms.module';
import { NewProjectComponent } from 'core-app/features/projects/components/new-project/new-project.component';
import { ReactiveFormsModule } from '@angular/forms';
import { OPSharedModule } from 'core-app/shared/shared.module';
import { CopyProjectComponent } from 'core-app/features/projects/components/copy-project/copy-project.component';
import { ProjectsComponent } from './components/projects/projects.component';

@NgModule({
  imports: [
    // Commons
    OPSharedModule,
    ReactiveFormsModule,

    OpenprojectHalModule,
    OpenprojectFieldsModule,
    UIRouterModule.forChild({
      states: PROJECTS_ROUTES,
      config: uiRouterProjectsConfiguration,
    }),
    DynamicFormsModule,
  ],
  declarations: [
    ProjectsComponent,
    NewProjectComponent,
    CopyProjectComponent,
  ],
})
export class OpenprojectProjectsModule {
}
