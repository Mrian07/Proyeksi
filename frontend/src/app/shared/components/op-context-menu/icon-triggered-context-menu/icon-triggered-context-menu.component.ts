

import {
  ChangeDetectorRef, Component, ElementRef, Injector, Input,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { OpContextMenuTrigger } from 'core-app/shared/components/op-context-menu/handlers/op-context-menu-trigger.directive';
import { OPContextMenuService } from 'core-app/shared/components/op-context-menu/op-context-menu.service';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { OpContextMenuItem } from 'core-app/shared/components/op-context-menu/op-context-menu.types';

@Component({
  selector: 'icon-triggered-context-menu',
  templateUrl: './icon-triggered-context-menu.component.html',
  styleUrls: ['./icon-triggered-context-menu.component.sass'],
})
export class IconTriggeredContextMenuComponent extends OpContextMenuTrigger {
  constructor(readonly elementRef:ElementRef,
    readonly opContextMenu:OPContextMenuService,
    readonly opModalService:OpModalService,
    readonly injector:Injector,
    readonly cdRef:ChangeDetectorRef,
    readonly I18n:I18nService) {
    super(elementRef, opContextMenu);
  }

  @Input('menu-items') menuItems:Function;

  protected async open(evt:JQuery.TriggeredEvent) {
    this.items = await this.buildItems();
    this.opContextMenu.show(this, evt);
  }

  /**
   * Positioning args for jquery-ui position.
   *
   * @param {Event} openerEvent
   */
  public positionArgs(evt:JQuery.TriggeredEvent) {
    const additionalPositionArgs = {
      my: 'right top',
      at: 'right bottom',
    };

    const position = super.positionArgs(evt);
    _.assign(position, additionalPositionArgs);

    return position;
  }

  private async buildItems() {
    const items:OpContextMenuItem[] = [];

    // Add action specific menu entries
    if (this.menuItems) {
      const additional = await this.menuItems();
      return items.concat(additional);
    }

    return items;
  }
}
