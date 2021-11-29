

import { TimezoneService } from 'core-app/core/datetime/timezone.service';

export class ActivityEntryInfo {
  constructor(public timezoneService:TimezoneService,
    public isReversed:boolean,
    public activities:any[],
    public activity:any,
    public index:number) {
  }

  public number(forceReverse = false) {
    return this.orderedIndex(this.index, forceReverse);
  }

  public get date() {
    return this.activityDate(this.activity);
  }

  public get dateOfPrevious():any {
    if (this.index > 0) {
      return this.activityDate(this.activities[this.index - 1]);
    }
  }

  public get href() {
    return this.activity.href;
  }

  public get identifier() {
    return `${this.href}-${this.version}`;
  }

  public get version() {
    return this.activity.version;
  }

  public get isNextDate() {
    return this.date !== this.dateOfPrevious;
  }

  public isInitial(forceReverse = false) {
    let activityNo = this.number(forceReverse);

    if (this.activity._type.indexOf('Activity') !== 0) {
      return false;
    }

    if (activityNo === 1) {
      return true;
    }

    while (--activityNo > 0) {
      const idx = this.orderedIndex(activityNo, forceReverse) - 1;
      const activity = this.activities[idx];
      if (!_.isNil(activity) && activity._type.indexOf('Activity') === 0) {
        return false;
      }
    }

    return true;
  }

  protected activityDate(activity:any) {
    // Force long date regardless of current date settings for headers
    return moment(activity.createdAt).format('LL');
  }

  protected orderedIndex(activityNo:number, forceReverse = false) {
    if (forceReverse || this.isReversed) {
      return this.activities.length - activityNo;
    }

    return activityNo + 1;
  }
}
