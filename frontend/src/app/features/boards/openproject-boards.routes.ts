

import { Ng2StateDeclaration, UIRouter } from '@uirouter/angular';
import { BoardsRootComponent } from 'core-app/features/boards/boards-root/boards-root.component';
import { BoardsIndexPageComponent } from 'core-app/features/boards/index-page/boards-index-page.component';
import { BoardPartitionedPageComponent } from 'core-app/features/boards/board/board-partitioned-page/board-partitioned-page.component';
import { BoardListContainerComponent } from 'core-app/features/boards/board/board-partitioned-page/board-list-container.component';
import { makeSplitViewRoutes } from 'core-app/features/work-packages/routing/split-view-routes.template';
import { WorkPackageSplitViewComponent } from 'core-app/features/work-packages/routing/wp-split-view/wp-split-view.component';

export const menuItemClass = 'board-view-menu-item';

export const BOARDS_ROUTES:Ng2StateDeclaration[] = [
  {
    name: 'boards',
    parent: 'optional_project',
    // The trailing slash is important
    // cf., https://community.openproject.com/wp/29754
    url: '/boards/?query_props',
    data: {
      bodyClasses: 'router--boards-view-base',
      menuItem: menuItemClass,
    },
    params: {
      // Use custom encoder/decoder that ensures validity of URL string
      query_props: { type: 'opQueryString', dynamic: true },
    },
    redirectTo: 'boards.list',
    component: BoardsRootComponent,
  },
  {
    name: 'boards.list',
    component: BoardsIndexPageComponent,
    data: {
      parent: 'boards',
      bodyClasses: 'router--boards-list-view',
      menuItem: menuItemClass,
    },
  },
  {
    name: 'boards.partitioned',
    url: '{board_id}',
    params: {
      board_id: { type: 'int' },
      isNew: { type: 'bool', inherit: false, dynamic: true },
    },
    data: {
      parent: 'boards',
      bodyClasses: 'router--boards-full-view',
      menuItem: menuItemClass,
    },
    reloadOnSearch: false,
    component: BoardPartitionedPageComponent,
    redirectTo: 'boards.partitioned.show',
  },
  {
    name: 'boards.partitioned.show',
    url: '',
    data: {
      baseRoute: 'boards.partitioned.show',
    },
    views: {
      'content-left': { component: BoardListContainerComponent },
    },
  },
  ...makeSplitViewRoutes(
    'boards.partitioned.show',
    menuItemClass,
    WorkPackageSplitViewComponent,
  ),
];

export function uiRouterBoardsConfiguration(uiRouter:UIRouter) {
  // Ensure boards/ are being redirected correctly
  // cf., https://community.openproject.com/wp/29754
  uiRouter.urlService.rules
    .when(
      new RegExp('^/projects/(.*)/boards$'),
      (match) => `/projects/${match[1]}/boards/`,
    );
}
