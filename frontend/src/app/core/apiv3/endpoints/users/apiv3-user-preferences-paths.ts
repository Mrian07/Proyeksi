

import { APIv3ResourcePath } from 'core-app/core/apiv3/paths/apiv3-resource';
import { Observable } from 'rxjs';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { HttpClient } from '@angular/common/http';
import { UserPreferencesModel } from 'core-app/features/user-preferences/state/user-preferences.model';

export class Apiv3UserPreferencesPaths extends APIv3ResourcePath<UserPreferencesModel> {
  @InjectField() http:HttpClient;

  /**
   * Perform a request to the backend to load preferences
   */
  public get():Observable<UserPreferencesModel> {
    return this
      .http
      .get<UserPreferencesModel>(
      this.path,
    );
  }

  /**
   * Perform a request to update preferences
   */
  public patch(payload:Partial<UserPreferencesModel>):Observable<UserPreferencesModel> {
    return this
      .http
      .patch<UserPreferencesModel>(
      this.path,
      payload,
      { withCredentials: true, responseType: 'json' },
    );
  }
}
