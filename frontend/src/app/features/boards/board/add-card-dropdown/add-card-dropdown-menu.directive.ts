

import {
  ChangeDetectorRef, Directive, ElementRef, Injector,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { AuthorisationService } from 'core-app/core/model-auth/model-auth.service';
import { OpContextMenuTrigger } from 'core-app/shared/components/op-context-menu/handlers/op-context-menu-trigger.directive';
import { OPContextMenuService } from 'core-app/shared/components/op-context-menu/op-context-menu.service';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { WorkPackageInlineCreateService } from 'core-app/features/work-packages/components/wp-inline-create/wp-inline-create.service';
import { BoardListComponent } from 'core-app/features/boards/board/board-list/board-list.component';

@Directive({
  selector: '[op-addCardDropdown]',
})
export class AddCardDropdownMenuDirective extends OpContextMenuTrigger {
  constructor(readonly elementRef:ElementRef,
    readonly opContextMenu:OPContextMenuService,
    readonly opModalService:OpModalService,
    readonly authorisationService:AuthorisationService,
    readonly wpInlineCreate:WorkPackageInlineCreateService,
    readonly boardList:BoardListComponent,
    readonly injector:Injector,
    readonly querySpace:IsolatedQuerySpace,
    readonly cdRef:ChangeDetectorRef,
    readonly I18n:I18nService) {
    super(elementRef, opContextMenu);
  }

  protected open(evt:JQuery.TriggeredEvent) {
    this.items = this.buildItems();
    this.opContextMenu.show(this, evt);
  }

  /**
   * Positioning args for jquery-ui position.
   *
   * @param {Event} openerEvent
   */
  public positionArgs(evt:JQuery.TriggeredEvent) {
    const additionalPositionArgs = {
      my: 'left top',
      at: 'left bottom',
    };

    const position = super.positionArgs(evt);
    _.assign(position, additionalPositionArgs);

    return position;
  }

  private buildItems() {
    return [
      {
        disabled: !this.wpInlineCreate.canAdd,
        linkText: this.I18n.t('js.card.add_new'),
        onClick: () => {
          this.boardList.addNewCard();
          return true;
        },
      },
      {
        disabled: !this.wpInlineCreate.canReference,
        linkText: this.I18n.t('js.relation_buttons.add_existing'),
        onClick: () => {
          this.boardList.addReferenceCard();
          return true;
        },
      },
    ];
  }
}
