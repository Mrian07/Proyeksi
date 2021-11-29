

import { Injector } from '@angular/core';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { HttpClient } from '@angular/common/http';
import { SimpleResource } from 'core-app/core/apiv3/paths/path-resources';

export type QueryOrder = { [wpId:string]:number };

export class APIV3QueryOrder extends SimpleResource {
  @InjectField() http:HttpClient;

  constructor(readonly injector:Injector,
    readonly basePath:string,
    readonly id:string|number) {
    super(basePath, id);
  }

  public get():Promise<QueryOrder> {
    return this.http
      .get<QueryOrder>(
      this.path,
    )
      .toPromise()
      .then((result) => result || {});
  }

  public update(delta:QueryOrder):Promise<string> {
    return this.http
      .patch(
        this.path,
        { delta },
        { withCredentials: true },
      )
      .toPromise()
      .then((response:{ t:string }) => response.t);
  }

  public delete(id:string, ...wpIds:string[]) {
    const delta:QueryOrder = {};
    wpIds.forEach((id) => delta[id] = -1);

    return this.update(delta);
  }
}
