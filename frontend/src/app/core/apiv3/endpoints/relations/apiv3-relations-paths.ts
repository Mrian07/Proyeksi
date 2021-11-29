

import { APIv3GettableResource, APIv3ResourceCollection } from 'core-app/core/apiv3/paths/apiv3-resource';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { from, Observable } from 'rxjs';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { RelationResource } from 'core-app/features/hal/resources/relation-resource';
import { map } from 'rxjs/operators';
import { buildApiV3Filter } from 'core-app/shared/helpers/api-v3/api-v3-filter-builder';

export class Apiv3RelationsPaths extends APIv3ResourceCollection<RelationResource, APIv3GettableResource<RelationResource>> {
  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'relations');
  }

  /**
   * Get all versions
   */
  public get():Observable<CollectionResource<RelationResource>> {
    return this
      .halResourceService
      .get<CollectionResource<RelationResource>>(this.path);
  }

  public loadInvolved(workPackageIds:string[]):Observable<RelationResource[]> {
    const validIds = _.filter(workPackageIds, (id) => /\d+/.test(id));

    if (validIds.length === 0) {
      return from([]);
    }

    return this
      .filtered(buildApiV3Filter('involved', '=', validIds))
      .get()
      .pipe(
        map((collection) => collection.elements),
      );
  }
}
