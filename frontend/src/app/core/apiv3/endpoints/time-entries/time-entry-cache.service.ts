

import { TimeEntryResource } from 'core-app/features/hal/resources/time-entry-resource';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { SchemaCacheService } from 'core-app/core/schemas/schema-cache.service';
import { States } from 'core-app/core/states/states.service';
import { Injector } from '@angular/core';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';
import { MultiInputState } from 'reactivestates';

export class TimeEntryCacheService extends StateCacheService<TimeEntryResource> {
  @InjectField() readonly states:States;

  @InjectField() readonly schemaCache:SchemaCacheService;

  constructor(readonly injector:Injector, state:MultiInputState<TimeEntryResource>) {
    super(state);
  }

  updateValue(id:string, val:TimeEntryResource):Promise<TimeEntryResource> {
    return this.schemaCache
      .ensureLoaded(val)
      .then(() => {
        this.putValue(id, val);
        return val;
      });
  }
}
