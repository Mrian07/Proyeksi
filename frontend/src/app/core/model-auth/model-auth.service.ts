

import { Injectable } from '@angular/core';
import { input } from 'reactivestates';
import { Observable } from 'rxjs';
import { takeUntil } from 'rxjs/operators';

export type ModelLinks = { [action:string]:any };
export type ModelLinksHash = { [model:string]:ModelLinks };

@Injectable({ providedIn: 'root' })
export class AuthorisationService {
  private links = input<ModelLinksHash>({});

  public initModelAuth(modelName:string, modelLinks:ModelLinks) {
    this.links.doModify((value:ModelLinksHash) => {
      const links = { ...value };
      links[modelName] = modelLinks;
      return links;
    });
  }

  public observeUntil(unsubscribe:Observable<any>) {
    return this.links.values$().pipe(takeUntil(unsubscribe));
  }

  public can(modelName:string, action:string) {
    const links:ModelLinksHash = this.links.getValueOr({});
    return links[modelName] && (action in links[modelName]);
  }

  public cannot(modelName:string, action:string) {
    return !this.can(modelName, action);
  }
}
