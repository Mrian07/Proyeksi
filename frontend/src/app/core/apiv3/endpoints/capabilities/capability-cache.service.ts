

import { CapabilityResource } from 'core-app/features/hal/resources/capability-resource';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { States } from 'core-app/core/states/states.service';
import { Injector } from '@angular/core';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';
import { MultiInputState } from 'reactivestates';

export class CapabilityCacheService extends StateCacheService<CapabilityResource> {
  @InjectField() readonly states:States;

  constructor(readonly injector:Injector, state:MultiInputState<CapabilityResource>) {
    super(state);
  }

  updateValue(id:string, val:CapabilityResource):Promise<CapabilityResource> {
    this.putValue(id, val);
    return Promise.resolve(val);
  }
}
