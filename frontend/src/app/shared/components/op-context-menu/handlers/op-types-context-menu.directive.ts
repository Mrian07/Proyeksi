

import { OpContextMenuItem } from 'core-app/shared/components/op-context-menu/op-context-menu.types';
import { StateService } from '@uirouter/core';
import { OPContextMenuService } from 'core-app/shared/components/op-context-menu/op-context-menu.service';
import { Directive, ElementRef, Input } from '@angular/core';
import { isClickedWithModifier } from 'core-app/shared/helpers/link-handling/link-handling';
import { OpContextMenuTrigger } from 'core-app/shared/components/op-context-menu/handlers/op-context-menu-trigger.directive';
import { BrowserDetector } from 'core-app/core/browser/browser-detector.service';
import { WorkPackageCreateService } from 'core-app/features/work-packages/components/wp-new/wp-create.service';
import { Highlighting } from 'core-app/features/work-packages/components/wp-fast-table/builders/highlighting/highlighting.functions';
import { TypeResource } from 'core-app/features/hal/resources/type-resource';

@Directive({
  selector: '[opTypesCreateDropdown]',
})
export class OpTypesContextMenuDirective extends OpContextMenuTrigger {
  @Input('projectIdentifier') public projectIdentifier:string|null|undefined;

  @Input('stateName') public stateName:string;

  @Input('dropdownActive') active:boolean;

  constructor(readonly elementRef:ElementRef,
    readonly opContextMenu:OPContextMenuService,
    readonly browserDetector:BrowserDetector,
    readonly wpCreate:WorkPackageCreateService,
    readonly $state:StateService) {
    super(elementRef, opContextMenu);
  }

  ngAfterViewInit():void {
    super.ngAfterViewInit();

    if (!this.active) {
      return;
    }

    // Force full-view create if in mobile view
    if (this.browserDetector.isMobile) {
      this.stateName = 'work-packages.new';
    }
  }

  protected open(evt:JQuery.TriggeredEvent) {
    this
      .wpCreate
      .getEmptyForm(this.projectIdentifier)
      .then((form) => {
        this.buildItems(form.schema.type.allowedValues);
        this.opContextMenu.show(this, evt);
      });
  }

  public get locals():{ showAnchorRight?:boolean, contextMenuId?:string, items:OpContextMenuItem[] } {
    return {
      items: this.items,
      contextMenuId: 'types-context-menu',
    };
  }

  private buildItems(types:TypeResource[]) {
    this.items = types.map((type:TypeResource) => ({
      disabled: false,
      linkText: type.name,
      href: this.$state.href(this.stateName, { type: type.id! }),
      ariaLabel: type.name,
      class: Highlighting.inlineClass('type', type.id!),
      onClick: ($event:JQuery.TriggeredEvent) => {
        if (isClickedWithModifier($event)) {
          return false;
        }

        this.$state.go(this.stateName, { type: type.id });
        return true;
      },
    }));
  }
}
