

import { Injectable } from '@angular/core';
import {
  Store,
  StoreConfig,
} from '@datorama/akita';
import { UserPreferencesModel } from 'core-app/features/user-preferences/state/user-preferences.model';

function createInitialState():UserPreferencesModel {
  return {
    autoHidePopups: true,
    commentSortDescending: false,
    hideMail: true,
    timeZone: null,
    warnOnLeavingUnsaved: true,
    notifications: [],
    dailyReminders: {
      enabled: true,
      times: ['08:00'],
    },
    workdays: [1, 2, 3, 4, 5],
    immediateReminders: {
      mentioned: false,
    },
    pauseReminders: {
      enabled: false,
    },
  };
}

@StoreConfig({ name: 'notification-settings' })
export class UserPreferencesStore extends Store<UserPreferencesModel> {
  constructor() {
    super(createInitialState());
  }
}
