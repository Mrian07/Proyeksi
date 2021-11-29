

import { Board } from 'core-app/features/boards/board/board';
import { Observable } from 'rxjs';
import { map, switchMap, tap } from 'rxjs/operators';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';
import { CachableAPIV3Resource } from 'core-app/core/apiv3/cache/cachable-apiv3-resource';
import { StateCacheService } from 'core-app/core/apiv3/cache/state-cache.service';
import { Apiv3BoardsPaths } from 'core-app/core/apiv3/virtual/apiv3-boards-paths';

export class APIv3BoardPath extends CachableAPIV3Resource<Board> {
  /**
   * Perform a request to the HalResourceService with the current path
   */
  protected load():Observable<Board> {
    return this
      .apiRoot
      .grids
      .id(this.id)
      .get()
      .pipe(
        map((grid) => {
          const newBoard = new Board(grid);

          newBoard.sortWidgets();

          return newBoard;
        }),
      );
  }

  /**
   * Save the changes to the board
   */
  public save(board:Board):Observable<Board> {
    return this
      .fetchSchema(board)
      .pipe(
        switchMap((schema:SchemaResource) => this
          .apiRoot
          .grids
          .id(board.grid)
          .patch(board.grid, schema)),
        map((grid) => {
          board.grid = grid;
          board.sortWidgets();
          return board;
        }),
        this.cacheResponse(),
      );
  }

  public delete():Observable<unknown> {
    return this
      .apiRoot
      .grids
      .id(this.id)
      .delete()
      .pipe(
        tap(() => this.cache.clearSome(this.id.toString())),
      );
  }

  private fetchSchema(board:Board):Observable<SchemaResource> {
    return this
      .apiRoot
      .grids
      .id(board.grid)
      .form
      .post({})
      .pipe(
        map((form) => form.schema),
      );
  }

  protected createCache():StateCacheService<Board> {
    return (this.parent as Apiv3BoardsPaths).cache;
  }
}
