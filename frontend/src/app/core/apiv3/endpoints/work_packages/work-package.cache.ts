

import { MultiInputState } from 'reactivestates';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { Injectable, Injector } from '@angular/core';
import { debugLog } from 'core-app/shared/helpers/debug_output';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { SchemaCacheService } from 'core-app/core/schemas/schema-cache.service';
import isNewResource from 'core-app/features/hal/helpers/is-new-resource';

@Injectable()
export class WorkPackageCache extends StateCacheService<WorkPackageResource> {
  @InjectField() private schemaCacheService:SchemaCacheService;

  constructor(readonly injector:Injector,
    state:MultiInputState<WorkPackageResource>) {
    super(state);
  }

  updateValue(id:string, val:WorkPackageResource):Promise<WorkPackageResource> {
    return this.schemaCacheService.ensureLoaded(val).then(() => {
      this.putValue(id, val);
      return val;
    });
  }

  updateWorkPackage(wp:WorkPackageResource, immediate = false):Promise<WorkPackageResource> {
    if (immediate || isNewResource(wp)) {
      return super.updateValue(wp.id!, wp);
    }
    return this.updateValue(wp.id!, wp);
  }

  updateWorkPackageList(list:WorkPackageResource[], skipOnIdentical = true) {
    list.forEach((i) => {
      const wp = i;
      const workPackageId = wp.id!;
      const state = this.multiState.get(workPackageId);

      // If the work package is new, ignore the schema
      if (isNewResource(wp)) {
        state.putValue(wp);
        return;
      }

      // Ensure the schema is loaded
      // so that no consumer needs to call schema#$load manually
      this.schemaCacheService.ensureLoaded(wp).then(() => {
        // Check if the work package has changed
        if (skipOnIdentical && state.hasValue() && _.isEqual(state.value!.$source, wp.$source)) {
          debugLog('Skipping identical work package from updating');
          return;
        }

        state.putValue(wp);
      });
    });
  }
}
