

import { APIv3GettableResource } from 'core-app/core/apiv3/paths/apiv3-resource';
import { WorkPackageCollectionResource } from 'core-app/features/hal/resources/wp-collection-resource';
import { Observable } from 'rxjs';
import { APIV3WorkPackagesPaths } from 'core-app/core/apiv3/endpoints/work_packages/api-v3-work-packages-paths';
import { take, tap } from 'rxjs/operators';
import { WorkPackageCache } from 'core-app/core/apiv3/endpoints/work_packages/work-package.cache';
import { States } from 'core-app/core/states/states.service';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';

export class ApiV3WorkPackageCachedSubresource extends APIv3GettableResource<WorkPackageCollectionResource> {
  @InjectField() private states:States;

  public get():Observable<WorkPackageCollectionResource> {
    return this
      .halResourceService
      .get<WorkPackageCollectionResource>(this.path)
      .pipe(
        tap((collection) => collection.schemas && this.updateSchemas(collection.schemas)),
        tap((collection) => this.cache.updateWorkPackageList(collection.elements)),
        take(1),
      );
  }

  protected get cache():WorkPackageCache {
    return (this.parent as APIV3WorkPackagesPaths).cache;
  }

  private updateSchemas(schemas:CollectionResource<SchemaResource>) {
    schemas.elements.forEach((schema) => {
      this.states.schemas.get(schema.href as string).putValue(schema);
    });
  }
}
