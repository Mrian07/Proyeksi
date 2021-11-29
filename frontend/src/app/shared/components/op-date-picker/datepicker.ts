

import * as moment from 'moment';
import flatpickr from 'flatpickr';
import { Instance } from 'flatpickr/dist/types/instance';
import { ConfigurationService } from 'core-app/core/config/configuration.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { rangeSeparator } from 'core-app/shared/components/op-date-picker/op-range-date-picker/op-range-date-picker.component';
import DateOption = flatpickr.Options.DateOption;

export class DatePicker {
  private datepickerFormat = 'Y-m-d';

  private datepickerCont:HTMLElement = document.querySelector(this.datepickerElemIdentifier)!;

  public datepickerInstance:Instance;

  private reshowTimeout:any;

  constructor(private datepickerElemIdentifier:string,
    private date:Date|Date[]|string[]|string,
    private options:flatpickr.Options.Options,
    private datepickerTarget:HTMLElement|null,
    private configurationService:ConfigurationService) {
    this.initialize(options);
  }

  private initialize(options:flatpickr.Options.Options) {
    const I18n = new I18nService();
    const firstDayOfWeek = this.configurationService.startOfWeek() as number;

    const mergedOptions = _.extend({}, options, {
      weekNumbers: true,
      getWeek(dateObj:Date) {
        return moment(dateObj).format('W');
      },
      dateFormat: this.datepickerFormat,
      defaultDate: this.date,
      locale: {
        weekdays: {
          shorthand: I18n.t('date.abbr_day_names'),
          longhand: I18n.t('date.day_names'),
        },
        months: {
          shorthand: I18n.t<string[]>('date.abbr_month_names').slice(1),
          longhand: I18n.t<string[]>('date.month_names').slice(1),
        },
        firstDayOfWeek,
        weekAbbreviation: I18n.t('date.abbr_week'),
        rangeSeparator: ` ${rangeSeparator} `,
      },
    });

    let datePickerInstances:Instance|Instance[];
    if (this.datepickerTarget) {
      datePickerInstances = flatpickr(this.datepickerTarget as Node, mergedOptions);
    } else {
      datePickerInstances = flatpickr(this.datepickerElemIdentifier, mergedOptions);
    }

    this.datepickerInstance = Array.isArray(datePickerInstances) ? datePickerInstances[0] : datePickerInstances;

    document.addEventListener('scroll', this.hideDuringScroll, true);
  }

  public clear() {
    this.datepickerInstance.clear();
  }

  public destroy() {
    this.hide();
    this.datepickerInstance.destroy();
  }

  public hide() {
    if (this.isOpen) {
      this.datepickerInstance.close();
    }

    document.removeEventListener('scroll', this.hideDuringScroll, true);
  }

  public show() {
    this.datepickerInstance.open();
    document.addEventListener('scroll', this.hideDuringScroll, true);
  }

  public setDates(dates:DateOption|DateOption[]) {
    this.datepickerInstance.setDate(dates);
  }

  public get isOpen():boolean {
    return this.datepickerInstance.isOpen;
  }

  private hideDuringScroll = (event:Event) => {
    // Prevent Firefox quirk: flatPicker emits
    // multiple scrolls event when it is open
    const target = event.target! as HTMLInputElement;

    if (target?.classList?.contains('flatpickr-monthDropdown-months') || target?.classList?.contains('flatpickr-input')) {
      return;
    }

    this.datepickerInstance.close();

    if (this.reshowTimeout) {
      clearTimeout(this.reshowTimeout);
    }

    this.reshowTimeout = setTimeout(() => {
      if (this.visibleAndActive()) {
        this.datepickerInstance.open();
      }
    }, 50);
  };

  private visibleAndActive() {
    try {
      return this.isInViewport(this.datepickerCont)
        && document.activeElement === this.datepickerCont;
    } catch (e) {
      console.error(`Failed to test visibleAndActive ${e}`);
      return false;
    }
  }

  private isInViewport(element:HTMLElement) {
    const rect = element.getBoundingClientRect();

    return (
      rect.top >= 0
      && rect.left >= 0
      && rect.bottom <= (window.innerHeight || document.documentElement.clientHeight)
      && rect.right <= (window.innerWidth || document.documentElement.clientWidth)
    );
  }
}
