

import { OpContextMenuItem } from 'core-app/shared/components/op-context-menu/op-context-menu.types';
import { OPContextMenuService } from 'core-app/shared/components/op-context-menu/op-context-menu.service';
import { Directive, ElementRef, Input } from '@angular/core';
import { OpContextMenuTrigger } from 'core-app/shared/components/op-context-menu/handlers/op-context-menu-trigger.directive';
import { WorkPackageResource } from "core-app/features/hal/resources/work-package-resource";
import { GitActionsMenuComponent } from './git-actions-menu.component';

@Directive({
  selector: '[gitActionsCopyDropdown]'
})
export class GitActionsMenuDirective extends OpContextMenuTrigger {
  @Input('gitActionsCopyDropdown-workPackage') public workPackage:WorkPackageResource;

  constructor(readonly elementRef:ElementRef,
              readonly opContextMenu:OPContextMenuService) {
    super(elementRef, opContextMenu);
  }

  protected open(evt:JQuery.TriggeredEvent) {
    this.opContextMenu.show(this, evt, GitActionsMenuComponent);
  }

  public get locals():{ showAnchorRight?:boolean, contextMenuId?:string, items:OpContextMenuItem[], workPackage:WorkPackageResource } {
    return {
      workPackage: this.workPackage,
      contextMenuId: 'github-integration-git-actions-menu',
      items: []
    };
  }
}

