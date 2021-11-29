

import { Ng2StateDeclaration } from '@uirouter/angular';

export const IAN_LAZY_ROUTES:Ng2StateDeclaration[] = [
  {
    name: 'notifications.**',
    url: '/notifications',
    loadChildren: () => import('./in-app-notifications.module').then((m) => m.OpenProjectInAppNotificationsModule),
  },
];
