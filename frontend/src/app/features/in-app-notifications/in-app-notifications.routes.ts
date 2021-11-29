

import { Ng2StateDeclaration } from '@uirouter/angular';
import { makeSplitViewRoutes } from 'core-app/features/work-packages/routing/split-view-routes.template';
import { WorkPackageSplitViewComponent } from 'core-app/features/work-packages/routing/wp-split-view/wp-split-view.component';
import { InAppNotificationCenterComponent } from 'core-app/features/in-app-notifications/center/in-app-notification-center.component';
import { InAppNotificationCenterPageComponent } from 'core-app/features/in-app-notifications/center/in-app-notification-center-page.component';
import { WorkPackagesBaseComponent } from 'core-app/features/work-packages/routing/wp-base/wp--base.component';
import { EmptyStateComponent } from './center/empty-state/empty-state.component';

export interface INotificationPageQueryParameters {
  filter?:string;
  name?:string;
}

export const IAN_ROUTES:Ng2StateDeclaration[] = [
  {
    name: 'notifications',
    parent: 'root',
    url: '/notifications?{filter:string}&{name:string}',
    data: {
      bodyClasses: 'router--work-packages-base',
    },
    redirectTo: 'notifications.center.show',
    views: {
      '!$default': { component: WorkPackagesBaseComponent },
    },
  },
  {
    name: 'notifications.center',
    component: InAppNotificationCenterPageComponent,
    redirectTo: 'notifications.center.show',
  },
  {
    name: 'notifications.center.show',
    data: {
      baseRoute: 'notifications.center.show',
    },
    views: {
      'content-left': { component: InAppNotificationCenterComponent },
      'content-right': { component: EmptyStateComponent },
    },
  },
  ...makeSplitViewRoutes(
    'notifications.center.show',
    undefined,
    WorkPackageSplitViewComponent,
  ),
];
