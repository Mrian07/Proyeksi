

import { APIv3GettableResource, APIv3ResourceCollection } from 'core-app/core/apiv3/paths/apiv3-resource';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { Observable } from 'rxjs';
import { HelpTextResource } from 'core-app/features/hal/resources/help-text-resource';

export class Apiv3HelpTextsPaths
  extends APIv3ResourceCollection<HelpTextResource, APIv3GettableResource<HelpTextResource>> {
  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'help_texts');
  }

  /**
   * Load a list of membership entries with a given list parameter filter
   * @param params
   */
  public get():Observable<CollectionResource<HelpTextResource>> {
    return this
      .halResourceService
      .get<CollectionResource<HelpTextResource>>(this.path);
  }
}
