

import { NgModule } from '@angular/core';
import { OPSharedModule } from 'core-app/shared/shared.module';
import { OpenprojectWorkPackagesModule } from 'core-app/features/work-packages/openproject-work-packages.module';
import { OpenprojectModalModule } from 'core-app/shared/components/modal/modal.module';
import { UIRouterModule } from '@uirouter/angular';
import { BoardListComponent } from 'core-app/features/boards/board/board-list/board-list.component';
import { BoardsRootComponent } from 'core-app/features/boards/boards-root/boards-root.component';
import { BoardInlineAddAutocompleterComponent } from 'core-app/features/boards/board/inline-add/board-inline-add-autocompleter.component';
import { BoardsToolbarMenuDirective } from 'core-app/features/boards/board/toolbar-menu/boards-toolbar-menu.directive';
import { BoardConfigurationModalComponent } from 'core-app/features/boards/board/configuration-modal/board-configuration.modal';
import { BoardsIndexPageComponent } from 'core-app/features/boards/index-page/boards-index-page.component';
import { BoardsMenuComponent } from 'core-app/features/boards/boards-sidebar/boards-menu.component';
import { NewBoardModalComponent } from 'core-app/features/boards/new-board-modal/new-board-modal.component';
import { AddListModalComponent } from 'core-app/features/boards/board/add-list-modal/add-list-modal.component';
import { BoardHighlightingTabComponent } from 'core-app/features/boards/board/configuration-modal/tabs/highlighting-tab.component';
import { AddCardDropdownMenuDirective } from 'core-app/features/boards/board/add-card-dropdown/add-card-dropdown-menu.directive';
import { BoardFilterComponent } from 'core-app/features/boards/board/board-filter/board-filter.component';
import { DragScrollModule } from 'cdk-drag-scroll';
import { BoardListMenuComponent } from 'core-app/features/boards/board/board-list/board-list-menu.component';
import { VersionBoardHeaderComponent } from 'core-app/features/boards/board/board-actions/version/version-board-header.component';
import { DynamicModule } from 'ng-dynamic-component';
import { BOARDS_ROUTES, uiRouterBoardsConfiguration } from 'core-app/features/boards/openproject-boards.routes';
import { BoardPartitionedPageComponent } from 'core-app/features/boards/board/board-partitioned-page/board-partitioned-page.component';
import { BoardListContainerComponent } from 'core-app/features/boards/board/board-partitioned-page/board-list-container.component';
import { BoardsMenuButtonComponent } from 'core-app/features/boards/board/toolbar-menu/boards-menu-button.component';
import { AssigneeBoardHeaderComponent } from 'core-app/features/boards/board/board-actions/assignee/assignee-board-header.component';
import { SubprojectBoardHeaderComponent } from 'core-app/features/boards/board/board-actions/subproject/subproject-board-header.component';
import { SubtasksBoardHeaderComponent } from 'core-app/features/boards/board/board-actions/subtasks/subtasks-board-header.component';
import { StatusBoardHeaderComponent } from 'core-app/features/boards/board/board-actions/status/status-board-header.component';
import { OpenprojectAutocompleterModule } from 'core-app/shared/components/autocompleter/openproject-autocompleter.module';
import { TileViewComponent } from './tile-view/tile-view.component';

@NgModule({
  imports: [
    OPSharedModule,
    OpenprojectWorkPackagesModule,
    OpenprojectModalModule,
    DragScrollModule,
    OpenprojectAutocompleterModule,

    // Dynamic Module for actions
    DynamicModule.withComponents([VersionBoardHeaderComponent]),

    // Routes for /boards
    UIRouterModule.forChild({
      states: BOARDS_ROUTES,
      config: uiRouterBoardsConfiguration,
    }),
  ],
  declarations: [
    BoardsIndexPageComponent,
    BoardPartitionedPageComponent,
    BoardListContainerComponent,
    BoardListComponent,
    BoardsRootComponent,
    BoardInlineAddAutocompleterComponent,
    BoardsMenuComponent,
    BoardHighlightingTabComponent,
    BoardConfigurationModalComponent,
    BoardsToolbarMenuDirective,
    BoardsMenuButtonComponent,
    NewBoardModalComponent,
    AddListModalComponent,
    AddCardDropdownMenuDirective,
    BoardListMenuComponent,
    BoardFilterComponent,
    VersionBoardHeaderComponent,
    AssigneeBoardHeaderComponent,
    SubprojectBoardHeaderComponent,
    SubtasksBoardHeaderComponent,
    StatusBoardHeaderComponent,
    TileViewComponent,
  ],
})
export class OpenprojectBoardsModule {
}
