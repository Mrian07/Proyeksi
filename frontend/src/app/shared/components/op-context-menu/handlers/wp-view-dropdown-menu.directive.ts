

import { OPContextMenuService } from 'core-app/shared/components/op-context-menu/op-context-menu.service';
import { Directive, ElementRef } from '@angular/core';
import { OpContextMenuTrigger } from 'core-app/shared/components/op-context-menu/handlers/op-context-menu-trigger.directive';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import {
  WorkPackageViewDisplayRepresentationService,
  wpDisplayCardRepresentation,
  wpDisplayListRepresentation,
} from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-display-representation.service';
import { WorkPackageViewTimelineService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-timeline.service';

@Directive({
  selector: '[wpViewDropdown]',
})
export class WorkPackageViewDropdownMenuDirective extends OpContextMenuTrigger {
  constructor(readonly elementRef:ElementRef,
    readonly opContextMenu:OPContextMenuService,
    readonly I18n:I18nService,
    readonly wpDisplayRepresentationService:WorkPackageViewDisplayRepresentationService,
    readonly wpTableTimeline:WorkPackageViewTimelineService) {
    super(elementRef, opContextMenu);
  }

  protected open(evt:JQuery.TriggeredEvent) {
    this.buildItems();
    this.opContextMenu.show(this, evt);
  }

  public get locals() {
    return {
      items: this.items,
      contextMenuId: 'wp-view-context-menu',
    };
  }

  private buildItems() {
    this.items = [];

    if (this.wpDisplayRepresentationService.current !== wpDisplayCardRepresentation) {
      this.items.push(
        {
          // Card View
          linkText: this.I18n.t('js.views.card'),
          icon: 'icon-view-card',
          onClick: (evt:any) => {
            this.wpDisplayRepresentationService.setDisplayRepresentation(wpDisplayCardRepresentation);
            if (this.wpTableTimeline.isVisible) {
              // Necessary for the timeline buttons to disappear
              this.wpTableTimeline.toggle();
            }
            return true;
          },
        },
      );
    }

    if (this.wpTableTimeline.isVisible || this.wpDisplayRepresentationService.current === wpDisplayCardRepresentation) {
      this.items.push(
        {
          // List View
          linkText: this.I18n.t('js.views.list'),
          icon: 'icon-view-list',
          onClick: (evt:any) => {
            this.wpDisplayRepresentationService.setDisplayRepresentation(wpDisplayListRepresentation);
            if (this.wpTableTimeline.isVisible) {
              this.wpTableTimeline.toggle();
            }
            return true;
          },
        },
      );
    }

    if (!this.wpTableTimeline.isVisible || this.wpDisplayRepresentationService.current === wpDisplayCardRepresentation) {
      this.items.push(
        {
          // List View with enabled Gantt
          linkText: this.I18n.t('js.views.timeline'),
          icon: 'icon-view-timeline',
          onClick: (evt:any) => {
            if (!this.wpTableTimeline.isVisible) {
              this.wpTableTimeline.toggle();
            }
            this.wpDisplayRepresentationService.setDisplayRepresentation(wpDisplayListRepresentation);
            return true;
          },
        },
      );
    }
  }
}