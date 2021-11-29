

import { MultiInputState } from 'reactivestates';
import { Injectable, Injector } from '@angular/core';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { SchemaCacheService } from 'core-app/core/schemas/schema-cache.service';
import { ProjectResource } from 'core-app/features/hal/resources/project-resource';

@Injectable()
export class ProjectCache extends StateCacheService<ProjectResource> {
  @InjectField() private schemaCacheService:SchemaCacheService;

  constructor(readonly injector:Injector,
    state:MultiInputState<ProjectResource>) {
    super(state);
  }

  updateValue(id:string, val:ProjectResource):Promise<ProjectResource> {
    return this.schemaCacheService.ensureLoaded(val).then(() => {
      this.putValue(id, val);
      return val;
    });
  }
}
