

import {
  Component, EventEmitter, Input, Output,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { AuthorisationService } from 'core-app/core/model-auth/model-auth.service';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { Board } from 'core-app/features/boards/board/board';
import { BoardActionsRegistryService } from 'core-app/features/boards/board/board-actions/board-actions-registry.service';
import { OpContextMenuItem } from 'core-app/shared/components/op-context-menu/op-context-menu.types';
import { BoardService } from 'core-app/features/boards/board/board.service';
import { BoardActionService } from 'core-app/features/boards/board/board-actions/board-action.service';

@Component({
  selector: 'board-list-menu',
  templateUrl: './board-list-menu.component.html',
})
export class BoardListMenuComponent {
  @Input() board:Board;

  @Output() onRemove = new EventEmitter<void>();

  constructor(readonly opModalService:OpModalService,
    readonly authorisationService:AuthorisationService,
    private readonly querySpace:IsolatedQuerySpace,
    private readonly boardService:BoardService,
    private readonly boardActionRegistry:BoardActionsRegistryService,
    readonly I18n:I18nService) {
  }

  public get menuItems() {
    return async () => {
      const items:OpContextMenuItem[] = [
        {
          disabled: !this.canDelete,
          linkText: this.I18n.t('js.boards.lists.delete'),
          onClick: () => {
            this.onRemove.emit();
            return true;
          },
        },
      ];

      // Add action specific menu entries
      if (this.board.isAction) {
        const additional = await this.actionService.getAdditionalListMenuItems(this.query);
        return items.concat(additional);
      }

      return items;
    };
  }

  private get actionService():BoardActionService {
    return this.boardActionRegistry.get(this.board.actionAttribute!);
  }

  private get canManage() {
    return this.boardService.canManage(this.board);
  }

  public canDelete() {
    return this.canManage && !!this.query.delete;
  }

  private get query() {
    return this.querySpace.query.value!;
  }
}
