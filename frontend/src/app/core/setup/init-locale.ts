

import * as moment from 'moment';

export function initializeLocale() {
  const meta = document.querySelector('meta[name=openproject_initializer]') as HTMLMetaElement;
  const locale = meta.dataset.locale || 'en';
  const firstDayOfWeek = parseInt(meta.dataset.firstDayOfWeek || '', 10);
  const firstWeekOfYear = parseInt(meta.dataset.firstWeekOfYear || '', 10);

  I18n.locale = locale;

  if (!Number.isNaN(firstDayOfWeek) && !Number.isNaN(firstWeekOfYear)) {
    I18n.firstDayOfWeek = firstDayOfWeek;
    moment.updateLocale(locale, {
      week: {
        dow: firstDayOfWeek,
        doy: 7 + firstDayOfWeek - firstWeekOfYear,
      },
    });
  }

  // Override the default pluralization function to allow
  // "other" to be used as a fallback for "one" in languages where one is not set
  // (japanese, for example)
  I18n.pluralization.default = function (count:number) {
    switch (count) {
      case 0:
        return ['zero', 'other'];
      case 1:
        return ['one', 'other'];
      default:
        return ['other'];
    }
  };

  return import(/* webpackChunkName: "locale" */ `../../../locales/${I18n.locale}.js`);
}
