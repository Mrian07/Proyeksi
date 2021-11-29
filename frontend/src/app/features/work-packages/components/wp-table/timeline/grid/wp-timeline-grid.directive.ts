
import { AfterViewInit, Component, ElementRef } from '@angular/core';
import * as moment from 'moment';
import { TimelineZoomLevel } from 'core-app/features/hal/resources/query-resource';
import { WorkPackageTimelineTableController } from '../container/wp-timeline-container.directive';
import {
  calculatePositionValueForDayCount,
  getTimeSlicesForHeader,
  timelineElementCssClass,
  timelineGridElementCssClass,
  TimelineViewParameters,
} from '../wp-timeline';
import Moment = moment.Moment;

function checkForWeekendHighlight(date:Moment, cell:HTMLElement) {
  const day = date.day();

  // Sunday = 0
  // Monday = 6
  if (day === 0 || day === 6) {
    cell.classList.add('grid-weekend');
  }
}

@Component({
  selector: 'wp-timeline-grid',
  template: '<div class="wp-table-timeline--grid"></div>',
})
export class WorkPackageTableTimelineGrid implements AfterViewInit {
  private activeZoomLevel:TimelineZoomLevel;

  private gridContainer:JQuery;

  constructor(private elementRef:ElementRef,
    public wpTimeline:WorkPackageTimelineTableController) {
  }

  ngAfterViewInit() {
    const $element = jQuery(this.elementRef.nativeElement);
    this.gridContainer = $element.find('.wp-table-timeline--grid');
    this.wpTimeline.onRefreshRequested('grid', (vp:TimelineViewParameters) => this.refreshView(vp));
  }

  refreshView(vp:TimelineViewParameters) {
    this.renderLabels(vp);
  }

  private renderLabels(vp:TimelineViewParameters) {
    if (this.activeZoomLevel === vp.settings.zoomLevel) {
      return;
    }

    this.gridContainer.empty();

    switch (vp.settings.zoomLevel) {
      case 'days':
        return this.renderLabelsDays(vp);
      case 'weeks':
        return this.renderLabelsWeeks(vp);
      case 'months':
        return this.renderLabelsMonths(vp);
      case 'quarters':
        return this.renderLabelsQuarters(vp);
      case 'years':
        return this.renderLabelsYears(vp);
    }

    this.activeZoomLevel = vp.settings.zoomLevel;
  }

  private renderLabelsDays(vp:TimelineViewParameters) {
    this.renderTimeSlices(vp, 'day', vp.dateDisplayStart, vp.dateDisplayEnd, (start, cell) => {
      cell.style.paddingTop = '1px';
      checkForWeekendHighlight(start, cell);
    });

    this.renderTimeSlices(vp, 'year', vp.dateDisplayStart, vp.dateDisplayEnd, (start, cell) => {
      cell.classList.add('-grid-highlight');
      cell.style.zIndex = '2';
    });
  }

  private renderLabelsWeeks(vp:TimelineViewParameters) {
    this.renderTimeSlices(vp, 'day', vp.dateDisplayStart, vp.dateDisplayEnd, (start, cell) => {
      checkForWeekendHighlight(start, cell);
    });

    this.renderTimeSlices(vp, 'week', vp.dateDisplayStart, vp.dateDisplayEnd, (start, cell) => {
      cell.classList.add('-grid-highlight');
    });

    this.renderTimeSlices(vp, 'year', vp.dateDisplayStart, vp.dateDisplayEnd, (start, cell) => {
      cell.classList.add('-grid-highlight');
      cell.style.zIndex = '2';
    });
  }

  private renderLabelsMonths(vp:TimelineViewParameters) {
    this.renderTimeSlices(vp, 'week', vp.dateDisplayStart, vp.dateDisplayEnd, (start, cell) => {
    });

    this.renderTimeSlices(vp, 'month', vp.dateDisplayStart, vp.dateDisplayEnd, (start, cell) => {
      cell.classList.add('-grid-highlight');
    });

    this.renderTimeSlices(vp, 'year', vp.dateDisplayStart, vp.dateDisplayEnd, (start, cell) => {
      cell.classList.add('-grid-highlight');
      cell.style.zIndex = '2';
    });
  }

  private renderLabelsQuarters(vp:TimelineViewParameters) {
    this.renderTimeSlices(vp, 'month', vp.dateDisplayStart, vp.dateDisplayEnd, (start, cell) => {
    });

    this.renderTimeSlices(vp, 'quarter', vp.dateDisplayStart, vp.dateDisplayEnd, (start, cell) => {
      cell.classList.add('-grid-highlight');
    });

    this.renderTimeSlices(vp, 'year', vp.dateDisplayStart, vp.dateDisplayEnd, (start, cell) => {
      cell.classList.add('-grid-highlight');
      cell.style.zIndex = '2';
    });
  }

  private renderLabelsYears(vp:TimelineViewParameters) {
    this.renderTimeSlices(vp, 'month', vp.dateDisplayStart, vp.dateDisplayEnd, (start, cell) => {
    });

    this.renderTimeSlices(vp, 'year', vp.dateDisplayStart, vp.dateDisplayEnd, (start, cell) => {
      cell.classList.add('-grid-highlight');
    });
  }

  renderTimeSlices(vp:TimelineViewParameters,
    unit:moment.unitOfTime.DurationConstructor,
    startView:Moment,
    endView:Moment,
    cellCallback:(start:Moment, cell:HTMLElement) => void) {
    const { inViewportAndBoundaries, rest } = getTimeSlicesForHeader(vp, unit, startView, endView);

    for (const [start, end] of inViewportAndBoundaries) {
      const cell = document.createElement('div');
      cell.classList.add(timelineElementCssClass, timelineGridElementCssClass);
      cell.style.left = calculatePositionValueForDayCount(vp, start.diff(startView, 'days'));
      cell.style.width = calculatePositionValueForDayCount(vp, end.diff(start, 'days') + 1);
      this.gridContainer[0].appendChild(cell);
      cellCallback(start, cell);
    }
    setTimeout(() => {
      for (const [start, end] of rest) {
        const cell = document.createElement('div');
        cell.classList.add(timelineElementCssClass, timelineGridElementCssClass);
        cell.style.left = calculatePositionValueForDayCount(vp, start.diff(startView, 'days'));
        cell.style.width = calculatePositionValueForDayCount(vp, end.diff(start, 'days') + 1);
        this.gridContainer[0].appendChild(cell);
        cellCallback(start, cell);
      }
    }, 0);
  }
}
