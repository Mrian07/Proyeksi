

import { Injectable, Injector } from '@angular/core';
import { WorkPackagesListChecksumService } from 'core-app/features/work-packages/components/wp-list/wp-list-checksum.service';
import { WorkPackagesListService } from 'core-app/features/work-packages/components/wp-list/wp-list.service';
import { TransitionService } from '@uirouter/core';
import { Subject } from 'rxjs';

@Injectable()
export class QueryParamListenerService {
  readonly wpListChecksumService:WorkPackagesListChecksumService = this.injector.get(WorkPackagesListChecksumService);

  readonly wpListService:WorkPackagesListService = this.injector.get(WorkPackagesListService);

  readonly $transitions:TransitionService = this.injector.get(TransitionService);

  public observe$ = new Subject<any>();

  public queryChangeListener:Function;

  constructor(readonly injector:Injector) {
    this.listenForQueryParamsChanged();
  }

  public listenForQueryParamsChanged():any {
    // Listen for param changes
    return this.queryChangeListener = this.$transitions.onSuccess({}, (transition):any => {
      const options = transition.options();
      const params = transition.params('to');

      const newChecksum = this.wpListService.getCurrentQueryProps(params);
      const newId:string = params.query_id ? params.query_id.toString() : null;

      // Avoid performing any changes when we're going to reload
      if (options.reload || (options.custom && options.custom.notify === false)) {
        return true;
      }

      return this.wpListChecksumService
        .executeIfOutdated(newId,
          newChecksum,
          () => {
            this.observe$.next(newChecksum);
          });
    });
  }

  public removeQueryChangeListener() {
    this.queryChangeListener();
  }
}
