

import { OPContextMenuService } from 'core-app/shared/components/op-context-menu/op-context-menu.service';
import { Directive, ElementRef } from '@angular/core';
import { OpContextMenuTrigger } from 'core-app/shared/components/op-context-menu/handlers/op-context-menu-trigger.directive';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageViewCollapsedGroupsService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-collapsed-groups.service';

@Directive({
  selector: '[wpGroupToggleDropdown]',
})
export class WorkPackageGroupToggleDropdownMenuDirective extends OpContextMenuTrigger {
  constructor(readonly elementRef:ElementRef,
    readonly opContextMenu:OPContextMenuService,
    readonly I18n:I18nService,
    readonly wpViewCollapsedGroups:WorkPackageViewCollapsedGroupsService) {
    super(elementRef, opContextMenu);
  }

  protected open(evt:JQuery.TriggeredEvent) {
    this.buildItems();
    this.opContextMenu.show(this, evt);
  }

  public get locals() {
    return {
      items: this.items,
      contextMenuId: 'wp-group-fold-context-menu',
    };
  }

  private buildItems() {
    this.items = [
      {
        disabled: this.wpViewCollapsedGroups.allGroupsAreCollapsed,
        linkText: this.I18n.t('js.button_collapse_all'),
        icon: 'icon-minus2',
        onClick: (evt:JQuery.TriggeredEvent) => {
          this.wpViewCollapsedGroups.setAllGroupsCollapseStateTo(true);

          return true;
        },
      },
      {
        disabled: this.wpViewCollapsedGroups.allGroupsAreExpanded,
        linkText: this.I18n.t('js.button_expand_all'),
        icon: 'icon-plus',
        onClick: (evt:JQuery.TriggeredEvent) => {
          this.wpViewCollapsedGroups.setAllGroupsCollapseStateTo(false);

          return true;
        },
      },
    ];
  }
}
