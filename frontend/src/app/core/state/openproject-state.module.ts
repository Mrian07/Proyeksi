

import {
  NgModule,
} from '@angular/core';
import { InAppNotificationsResourceService } from './in-app-notifications/in-app-notifications.service';
import { ProjectsResourceService } from './projects/projects.service';

@NgModule({
  providers: [
    InAppNotificationsResourceService,
    ProjectsResourceService,
  ],
})
export class OpenProjectStateModule {
}
