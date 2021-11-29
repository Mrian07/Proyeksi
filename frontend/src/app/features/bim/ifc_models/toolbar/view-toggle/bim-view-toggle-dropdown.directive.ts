

import { OPContextMenuService } from 'core-app/shared/components/op-context-menu/op-context-menu.service';
import { Directive, ElementRef } from '@angular/core';
import { OpContextMenuTrigger } from 'core-app/shared/components/op-context-menu/handlers/op-context-menu-trigger.directive';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { StateService } from '@uirouter/core';
import {
  bimListViewIdentifier,
  bimSplitViewCardsIdentifier,
  bimSplitViewListIdentifier,
  bimTableViewIdentifier,
  bimViewerViewIdentifier,
  BimViewService,
} from 'core-app/features/bim/ifc_models/pages/viewer/bim-view.service';
import { ViewerBridgeService } from 'core-app/features/bim/bcf/bcf-viewer-bridge/viewer-bridge.service';
import { WorkPackageViewDisplayRepresentationService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-display-representation.service';
import { WorkPackageFiltersService } from 'core-app/features/work-packages/components/filters/wp-filters/wp-filters.service';

@Directive({
  selector: '[bimViewDropdown]',
})
export class BimViewToggleDropdownDirective extends OpContextMenuTrigger {
  constructor(readonly elementRef:ElementRef,
    readonly opContextMenu:OPContextMenuService,
    readonly bimView:BimViewService,
    readonly I18n:I18nService,
    readonly state:StateService,
    readonly wpFiltersService:WorkPackageFiltersService,
    readonly viewerBridgeService:ViewerBridgeService,
    readonly wpDisplayRepresentation:WorkPackageViewDisplayRepresentationService) {
    super(elementRef, opContextMenu);
  }

  protected open(evt:JQuery.TriggeredEvent) {
    this.buildItems();
    this.opContextMenu.show(this, evt);
  }

  public get locals() {
    return {
      items: this.items,
      contextMenuId: 'bim-view-context-menu',
    };
  }

  private buildItems() {
    const { current } = this.bimView;
    const items = this.viewerBridgeService.shouldShowViewer
      ? [bimViewerViewIdentifier, bimListViewIdentifier, bimSplitViewCardsIdentifier, bimSplitViewListIdentifier, bimTableViewIdentifier]
      : [bimListViewIdentifier, bimTableViewIdentifier];

    this.items = items
      .map((key) => ({
        hidden: key === current,
        linkText: this.bimView.text[key],
        icon: this.bimView.icon[key],
        onClick: () => {
          // Close filter section
          if (this.wpFiltersService.visible) {
            this.wpFiltersService.toggleVisibility();
          }

          switch (key) {
          // This project controls the view representation of the data through
          // the wpDisplayRepresentation service that modifies the QuerySpace
          // to inform the rest of the app about which display mode is currently
          // active (this.querySpace.query.live$).
          // Under the hood it is done by modifying the params of actual route.
          // Because of that, it is not possible to call this.state.go and
          // this.wpDisplayRepresentation.setDisplayRepresentation at the same
          // time, it raises a route error (The transition has been superseded by
          // a different transition...). To avoid this error, we are passing
          // a cards params to inform the view about the display representation mode
          // it has to show (cards or list).
            case bimListViewIdentifier:
              this.state.go('bim.partitioned.list', { cards: true });
              break;
            case bimTableViewIdentifier:
              this.state.go('bim.partitioned.list', { cards: false });
              break;
            case bimViewerViewIdentifier:
              this.state.go('bim.partitioned.model');
              break;
            case bimSplitViewCardsIdentifier:
              this.state.go('bim.partitioned.split', { cards: true });
              break;
            case bimSplitViewListIdentifier:
              this.state.go('bim.partitioned.split', { cards: false });
              break;
          }

          return true;
        },
      }));
  }
}
