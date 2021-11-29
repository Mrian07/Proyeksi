

import { Injectable } from '@angular/core';
import { Store, StoreConfig } from '@datorama/akita';
import { CapabilityResource } from 'core-app/features/hal/resources/capability-resource';

export interface CurrentUser {
  id:string|null;
  name:string|null;
  mail:string|null;
}

export interface CurrentUserState extends CurrentUser {
  capabilities:CapabilityResource[]|null;
}

export function createInitialState():CurrentUserState {
  return {
    id: null,
    name: null,
    mail: null,
    capabilities: null,
  };
}

@Injectable()
@StoreConfig({ name: 'current-user' })
export class CurrentUserStore extends Store<CurrentUserState> {
  constructor() {
    super(createInitialState());
  }
}
