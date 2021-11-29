
import {
  Component,
  ElementRef,
  OnInit,
} from '@angular/core';
import { States } from 'core-app/core/states/states.service';
import { WorkPackageTimelineTableController } from '../container/wp-timeline-container.directive';
import { TimelineViewParameters } from '../wp-timeline';
import {
  TimelineStaticElement,
  timelineStaticElementCssClassname,
} from './timeline-static-element';
import { TodayLineElement } from './wp-timeline.today-line';

@Component({
  selector: 'wp-timeline-static-elements',
  template: '<div class="wp-table-timeline--static-elements"></div>'
})
export class WorkPackageTableTimelineStaticElements implements OnInit {
  public $element:HTMLElement;

  private container:HTMLElement;

  private elements:TimelineStaticElement[];

  constructor(elementRef:ElementRef,
    public states:States,
    public workPackageTimelineTableController:WorkPackageTimelineTableController) {
    this.$element = elementRef.nativeElement;

    this.elements = [
      new TodayLineElement(),
    ];
  }

  ngOnInit() {
    this.container = this.$element.querySelector('.wp-table-timeline--static-elements') as HTMLElement;
    this.workPackageTimelineTableController
      .onRefreshRequested('static elements', (vp:TimelineViewParameters) => this.update(vp));
  }

  private update(vp:TimelineViewParameters) {
    this.removeAllVisibleElements();
    this.renderElements(vp);
  }

  private removeAllVisibleElements() {
    this
      .container
      .querySelectorAll(`.${timelineStaticElementCssClassname}`)
      .forEach((el) => el.remove());
  }

  private renderElements(vp:TimelineViewParameters) {
    for (const e of this.elements) {
      this.container.appendChild(e.render(vp));
    }
  }
}
