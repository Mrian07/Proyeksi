

import { APIv3ResourceCollection } from 'core-app/core/apiv3/paths/apiv3-resource';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { Observable } from 'rxjs';
import {
  Apiv3ListParameters,
  ApiV3ListFilter,
  listParamsString,
} from 'core-app/core/apiv3/paths/apiv3-list-resource.interface';
import { Apiv3NotificationPaths } from 'core-app/core/apiv3/endpoints/notifications/apiv3-notification-paths';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { HttpClient } from '@angular/common/http';
import { IHALCollection } from 'core-app/core/apiv3/types/hal-collection.type';
import { ID } from '@datorama/akita';
import { InAppNotification } from 'core-app/core/state/in-app-notifications/in-app-notification.model';

export class Apiv3NotificationsPaths
  extends APIv3ResourceCollection<InAppNotification, Apiv3NotificationPaths> {
  @InjectField() http:HttpClient;

  constructor(protected apiRoot:APIV3Service,
    protected basePath:string) {
    super(apiRoot, basePath, 'notifications', Apiv3NotificationPaths);
  }

  public facet(facet:string, params?:Apiv3ListParameters):Observable<IHALCollection<InAppNotification>> {
    if (facet === 'unread') {
      return this.unread(params);
    }
    return this.list(params);
  }

  /**
   * Load a list of events with a given list parameter filter
   * @param params
   */
  public list(params?:Apiv3ListParameters):Observable<IHALCollection<InAppNotification>> {
    return this
      .http
      .get<IHALCollection<InAppNotification>>(this.path + listParamsString(params));
  }

  public listPath(params?:Apiv3ListParameters):string {
    return this.path + listParamsString(params);
  }

  /**
   * Load unread events
   */
  public unread(additional?:Apiv3ListParameters):Observable<IHALCollection<InAppNotification>> {
    const unreadFilter:ApiV3ListFilter = ['readIAN', '=', false];
    const filters = [
      ...(additional?.filters ? additional.filters : []),
      unreadFilter,
    ];
    const params:Apiv3ListParameters = {
      ...additional,
      filters,
    };

    return this.list(params);
  }

  /**
   * Mark all notifications as read
   * @param ids
   */
  public markRead(ids:Array<ID>):Observable<unknown> {
    return this
      .http
      .post(
        `${this.path}/read_ian${listParamsString({ filters: [['id', '=', ids.map((id) => id.toString())]] })}`,
        {},
        {
          withCredentials: true,
          responseType: 'json',
        },
      );
  }
}
