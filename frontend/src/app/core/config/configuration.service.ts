
import { Injectable } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { ConfigurationResource } from 'core-app/features/hal/resources/configuration-resource';
import * as moment from 'moment';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

@Injectable({ providedIn: 'root' })
export class ConfigurationService {
  // fetches configuration from the ApiV3 endpoint
  // TODO: this currently saves the request between page reloads,
  // but could easily be stored in localStorage
  private configuration:ConfigurationResource;

  public initialized:Promise<boolean>;

  public constructor(readonly I18n:I18nService,
    readonly apiV3Service:APIV3Service) {
    this.initialized = this.loadConfiguration().then(() => true).catch(() => false);
  }

  public commentsSortedInDescendingOrder() {
    return this.userPreference('commentSortDescending');
  }

  public warnOnLeavingUnsaved() {
    return this.userPreference('warnOnLeavingUnsaved');
  }

  public autoHidePopups() {
    return this.userPreference('autoHidePopups');
  }

  public isTimezoneSet() {
    return !!this.timezone();
  }

  public timezone() {
    return this.userPreference('timeZone');
  }

  public isDirectUploads() {
    return !!this.prepareAttachmentURL;
  }

  public get prepareAttachmentURL() {
    return _.get(this.configuration, ['prepareAttachment', 'href']);
  }

  public get maximumAttachmentFileSize() {
    return this.systemPreference('maximumAttachmentFileSize');
  }

  public get perPageOptions() {
    return this.systemPreference('perPageOptions');
  }

  public dateFormatPresent() {
    return !!this.systemPreference('dateFormat');
  }

  public dateFormat() {
    return this.systemPreference('dateFormat');
  }

  public timeFormatPresent() {
    return !!this.systemPreference('timeFormat');
  }

  public timeFormat() {
    return this.systemPreference('timeFormat');
  }

  public startOfWeekPresent() {
    return !!this.systemPreference('startOfWeek');
  }

  public startOfWeek():number {
    if (this.startOfWeekPresent()) {
      return this.systemPreference('startOfWeek');
    }
    return moment.localeData(I18n.locale).firstDayOfWeek();
  }

  private loadConfiguration() {
    return this
      .apiV3Service
      .configuration
      .get()
      .toPromise()
      .then((configuration) => {
        this.configuration = configuration;
      });
  }

  private userPreference(pref:string) {
    return _.get(this.configuration, ['userPreferences', pref]);
  }

  private systemPreference(pref:string) {
    return _.get(this.configuration, pref);
  }
}
