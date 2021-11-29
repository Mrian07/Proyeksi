

import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, OnInit,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import {
  WorkPackageViewDisplayRepresentationService,
  wpDisplayCardRepresentation,
  wpDisplayListRepresentation,
} from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-display-representation.service';
import { WorkPackageViewTimelineService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-timeline.service';
import { combineLatest } from 'rxjs';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';

@Component({
  template: `
    <button class="button"
            id="wp-view-toggle-button"
            wpViewDropdown>
      <op-icon icon-classes="button--icon icon-view-{{view}}"></op-icon>
      <span class="button--text"
            aria-hidden="true"
            [textContent]="text[view]">
        </span>
      <op-icon icon-classes="button--icon icon-small icon-pulldown"></op-icon>
    </button>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'wp-view-toggle-button',
})
export class WorkPackageViewToggleButtonComponent extends UntilDestroyedMixin implements OnInit {
  public view:string;

  public text:any = {
    card: this.I18n.t('js.views.card'),
    list: this.I18n.t('js.views.list'),
    timeline: this.I18n.t('js.views.timeline'),
  };

  constructor(readonly I18n:I18nService,
    readonly cdRef:ChangeDetectorRef,
    readonly wpDisplayRepresentationService:WorkPackageViewDisplayRepresentationService,
    readonly wpTableTimeline:WorkPackageViewTimelineService) {
    super();
  }

  ngOnInit() {
    const statesCombined = combineLatest([
      this.wpDisplayRepresentationService.live$(),
      this.wpTableTimeline.live$(),
    ]);

    statesCombined.pipe(
      this.untilDestroyed(),
    ).subscribe(([display, timelines]) => {
      this.detectView(display, timelines.visible);
      this.cdRef.detectChanges();
    });
  }

  public detectView(display:string|null, timelineVisible:boolean) {
    if (display === wpDisplayCardRepresentation) {
      this.view = wpDisplayCardRepresentation;
      return;
    }

    if (timelineVisible) {
      this.view = 'timeline';
    } else {
      this.view = wpDisplayListRepresentation;
    }
  }
}
