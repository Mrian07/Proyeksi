

import * as moment from 'moment';
import { calculatePositionValueForDayCount, TimelineViewParameters } from '../wp-timeline';
import { TimelineStaticElement } from './timeline-static-element';

export class TodayLineElement extends TimelineStaticElement {
  protected finishElement(elem:HTMLElement, vp:TimelineViewParameters):HTMLElement {
    const offsetToday = vp.now.diff(vp.dateDisplayStart, 'days');
    const dayProgress = moment().hour() / 24;
    elem.style.left = calculatePositionValueForDayCount(vp, offsetToday + dayProgress);

    return elem;
  }

  public get identifier():string {
    return 'wp-timeline-static-element-today-line';
  }
}
