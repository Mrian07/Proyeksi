

import { Ng2StateDeclaration } from '@uirouter/angular';

export const MY_ACCOUNT_LAZY_ROUTES:Ng2StateDeclaration[] = [
  {
    name: 'my_notifications.**',
    url: '/my/notifications',
    loadChildren: () => import('./user-preferences.module').then((m) => m.ProyeksiAppMyAccountModule),
  },
  {
    name: 'user_notifications.**',
    url: '/users/:userId/edit/notifications',
    loadChildren: () => import('./user-preferences.module').then((m) => m.ProyeksiAppMyAccountModule),
  },
  {
    name: 'my_reminders.**',
    url: '/my/reminders',
    loadChildren: () => import('./user-preferences.module').then((m) => m.ProyeksiAppMyAccountModule),
  },
  {
    name: 'user_reminders.**',
    url: '/users/:userId/edit/reminders',
    loadChildren: () => import('./user-preferences.module').then((m) => m.ProyeksiAppMyAccountModule),
  },
];
