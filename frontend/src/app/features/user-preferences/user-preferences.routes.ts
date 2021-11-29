

import { Ng2StateDeclaration } from '@uirouter/angular';
import { NotificationsSettingsPageComponent } from 'core-app/features/user-preferences/notifications-settings/page/notifications-settings-page.component';
import { ReminderSettingsPageComponent } from './reminder-settings/page/reminder-settings-page.component';

export const MY_ACCOUNT_ROUTES:Ng2StateDeclaration[] = [
  {
    name: 'my_notifications',
    url: '/my/notifications',
    component: NotificationsSettingsPageComponent,
  },
  {
    name: 'user_notifications',
    url: '/users/:userId/edit/notifications',
    component: NotificationsSettingsPageComponent,
  },
  {
    name: 'my_reminders',
    url: '/my/reminders',
    component: ReminderSettingsPageComponent,
  },
  {
    name: 'user_reminders',
    url: '/users/:userId/edit/reminders',
    component: ReminderSettingsPageComponent,
  },
];
