

import { APIv3GettableResource, APIv3ResourceCollection } from 'core-app/core/apiv3/paths/apiv3-resource';
import { TimeEntryResource } from 'core-app/features/hal/resources/time-entry-resource';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { Observable } from 'rxjs';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import {
  Apiv3ListParameters,
  Apiv3ListResourceInterface,
  listParamsString,
} from 'core-app/core/apiv3/paths/apiv3-list-resource.interface';
import { NewsResource } from 'core-app/features/hal/resources/news-resource';

export class Apiv3NewsPaths
  extends APIv3ResourceCollection<NewsResource, APIv3GettableResource<NewsResource>>
  implements Apiv3ListResourceInterface<NewsResource> {
  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'news');
  }

  /**
   * Load a list of time entries with a given list parameter filter
   * @param params
   */
  public list(params?:Apiv3ListParameters):Observable<CollectionResource<NewsResource>> {
    return this
      .halResourceService
      .get<CollectionResource<TimeEntryResource>>(this.path + listParamsString(params));
  }
}
