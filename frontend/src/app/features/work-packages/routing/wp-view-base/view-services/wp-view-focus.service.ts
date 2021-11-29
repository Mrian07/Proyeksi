

import { Injectable } from '@angular/core';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { Observable } from 'rxjs';
import { distinctUntilChanged, map } from 'rxjs/operators';
import { WorkPackageViewSelectionService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-selection.service';
import { WorkPackageViewBaseService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-base.service';
import { QueryResource } from 'core-app/features/hal/resources/query-resource';
import { WorkPackageCollectionResource } from 'core-app/features/hal/resources/wp-collection-resource';

export interface WPFocusState {
  workPackageId:string;
  focusAfterRender:boolean;
}

@Injectable()
export class WorkPackageViewFocusService extends WorkPackageViewBaseService<WPFocusState> {
  constructor(public querySpace:IsolatedQuerySpace,
    public wpTableSelection:WorkPackageViewSelectionService) {
    super(querySpace);
  }

  public isFocused(workPackageId:string) {
    return this.focusedWorkPackage === workPackageId;
  }

  public ifShouldFocus(callback:(workPackageId:string) => void) {
    const value = this.current;

    if (value && value.focusAfterRender) {
      callback(value.workPackageId);
      value.focusAfterRender = false;
      this.update(value);
    }
  }

  public get focusedWorkPackage():string|null {
    const value = this.current;

    if (value) {
      return value.workPackageId;
    }

    // Return the first result if none selected
    const results = this.querySpace.results.value;
    if (results && results.elements.length > 0) {
      return results.elements[0].id!.toString();
    }

    return null;
  }

  public whenChanged():Observable<string> {
    return this.live$()
      .pipe(
        map((val:WPFocusState) => val.workPackageId),
        distinctUntilChanged(),
      );
  }

  public updateFocus(workPackageId:string, setFocusAfterRender = false) {
    // Set the selection to this row, if nothing else is selected.
    if (this.wpTableSelection.isEmpty) {
      this.wpTableSelection.setRowState(workPackageId, true);
    }
    this.update({ workPackageId, focusAfterRender: setFocusAfterRender });
  }

  valueFromQuery(query:QueryResource, results:WorkPackageCollectionResource):WPFocusState|undefined {
    return undefined;
  }
}
