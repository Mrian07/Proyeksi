

import { Moment } from 'moment';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { OnInit, Directive } from '@angular/core';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';
import { QueryFilterInstanceResource } from 'core-app/features/hal/resources/query-filter-instance-resource';

@Directive()
export abstract class AbstractDateTimeValueController extends UntilDestroyedMixin implements OnInit {
  public filter:QueryFilterInstanceResource;

  constructor(protected I18n:I18nService,
    protected timezoneService:TimezoneService) {
    super();
  }

  ngOnInit() {
    _.remove(this.filter.values as string[], (value) => !this.timezoneService.isValidISODateTime(value));
  }

  public abstract get lowerBoundary():Moment|null;

  public abstract get upperBoundary():Moment|null;

  public isoDateParser(data:any) {
    if (!this.timezoneService.isValidISODate(data)) {
      return '';
    }
    const d = this.timezoneService.parseISODatetime(data);
    return this.timezoneService.formattedISODateTime(d);
  }

  public isoDateFormatter(data:any) {
    if (!this.timezoneService.isValidISODateTime(data)) {
      return '';
    }
    const d = this.timezoneService.parseISODatetime(data);
    return this.timezoneService.formattedISODate(d);
  }

  public get isTimeZoneDifferent() {
    const value = this.lowerBoundary || this.upperBoundary;

    if (!value) {
      return false;
    }
    return value.hours() !== 0 || value.minutes() !== 0;
  }

  public get timeZoneText() {
    if (this.lowerBoundary && this.upperBoundary) {
      return this.I18n.t('js.filter.time_zone_converted.two_values',
        {
          from: this.lowerBoundary.format('YYYY-MM-DD HH:mm'),
          to: this.upperBoundary.format('YYYY-MM-DD HH:mm'),
        });
    } if (this.upperBoundary) {
      return this.I18n.t('js.filter.time_zone_converted.only_end',
        { to: this.upperBoundary.format('YYYY-MM-DD HH:mm') });
    } if (this.lowerBoundary) {
      return this.I18n.t('js.filter.time_zone_converted.only_start',
        { from: this.lowerBoundary.format('YYYY-MM-DD HH:mm') });
    }

    return '';
  }
}
