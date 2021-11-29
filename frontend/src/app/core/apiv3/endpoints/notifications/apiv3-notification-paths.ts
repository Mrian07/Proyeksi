

import { APIv3GettableResource } from 'core-app/core/apiv3/paths/apiv3-resource';
import { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { InAppNotification } from 'core-app/core/state/in-app-notifications/in-app-notification.model';

export class Apiv3NotificationPaths extends APIv3GettableResource<InAppNotification> {
  @InjectField() http:HttpClient;

  public markRead():Observable<unknown> {
    return this
      .http
      .post(
        `${this.path}/read_ian`,
        {},
        {
          withCredentials: true,
          responseType: 'json',
        },
      );
  }

  public markUnread():Observable<unknown> {
    return this
      .http
      .post(
        `${this.path}/unread_ian`,
        {},
        {
          withCredentials: true,
          responseType: 'json',
        },
      );
  }
}
