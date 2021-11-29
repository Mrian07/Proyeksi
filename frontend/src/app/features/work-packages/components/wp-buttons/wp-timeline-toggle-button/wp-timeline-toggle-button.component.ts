

import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, OnInit,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageViewTimelineService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-timeline.service';
import { TimelineZoomLevel } from 'core-app/features/hal/resources/query-resource';
import { AbstractWorkPackageButtonComponent, ButtonControllerText } from '../wp-buttons.module';

export interface TimelineButtonText extends ButtonControllerText {
  zoomOut:string;
  zoomIn:string;
  zoomAuto:string;
}

@Component({
  templateUrl: './wp-timeline-toggle-button.html',
  styleUrls: ['./wp-timeline-toggle-button.sass'],
  selector: 'wp-timeline-toggle-button',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class WorkPackageTimelineButtonComponent extends AbstractWorkPackageButtonComponent implements OnInit {
  public buttonId = 'work-packages-timeline-toggle-button';

  public iconClass = 'icon-view-timeline';

  private activateLabel:string;

  private deactivateLabel:string;

  public text:TimelineButtonText;

  public minZoomLevel:TimelineZoomLevel = 'days';

  public maxZoomLevel:TimelineZoomLevel = 'years';

  public isAutoZoom = false;

  public isMaxLevel = false;

  public isMinLevel = false;

  constructor(readonly I18n:I18nService,
    readonly cdRef:ChangeDetectorRef,
    public wpTableTimeline:WorkPackageViewTimelineService) {
    super(I18n);

    this.activateLabel = I18n.t('js.timelines.button_activate');
    this.deactivateLabel = I18n.t('js.timelines.button_deactivate');

    this.text.zoomIn = I18n.t('js.timelines.zoom.in');
    this.text.zoomOut = I18n.t('js.timelines.zoom.out');
    this.text.zoomAuto = I18n.t('js.timelines.zoom.auto');
  }

  ngOnInit():void {
    this.wpTableTimeline
      .live$()
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe(() => {
        this.isAutoZoom = this.wpTableTimeline.isAutoZoom();
        this.isActive = this.wpTableTimeline.isVisible;
        this.cdRef.detectChanges();
      });

    this.wpTableTimeline
      .appliedZoomLevel$
      .values$()
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe((current) => {
        this.isMaxLevel = current === this.maxZoomLevel;
        this.isMinLevel = current === this.minZoomLevel;
        this.cdRef.detectChanges();
      });
  }

  public get label():string {
    if (this.isActive) {
      return this.deactivateLabel;
    }
    return this.activateLabel;
  }

  public isToggle():boolean {
    return true;
  }

  public updateZoomWithDelta(delta:number) {
    this.wpTableTimeline.updateZoomWithDelta(delta);
  }

  public performAction(event:Event) {
    this.toggleTimeline();
  }

  public toggleTimeline() {
    this.wpTableTimeline.toggle();
  }

  public enableAutoZoom() {
    this.wpTableTimeline.enableAutozoom();
  }

  public getAutoZoomToggleClass():string {
    return this.isAutoZoom ? '-disabled' : '';
  }
}
