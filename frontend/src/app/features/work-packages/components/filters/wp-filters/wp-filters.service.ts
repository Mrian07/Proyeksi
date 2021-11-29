

import { Injectable } from '@angular/core';
import { input } from 'reactivestates';
import { Observable } from 'rxjs';
import { takeUntil } from 'rxjs/operators';

@Injectable()
export class WorkPackageFiltersService {
  private readonly state = input<boolean>(false);

  public get visible() {
    return this.state.getValueOr(false);
  }

  public set visible(val:boolean) {
    this.state.putValue(val);
  }

  public observeUntil(unsubscribe:Observable<any>) {
    return this.state.values$().pipe(takeUntil(unsubscribe));
  }

  public toggleVisibility() {
    this.state.doModify((current) => !current);
  }
}
