

import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class HookService {
  private hooks:{ [hook:string]:Function[] } = {};

  public register(id:string, callback:Function) {
    if (!callback) {
      return;
    }

    if (!this.hooks[id]) {
      this.hooks[id] = [];
    }

    this.hooks[id].push(callback);
  }

  public call(id:string, ...params:any[]):any[] {
    const results = [];

    if (this.hooks[id]) {
      for (let x = 0; x < this.hooks[id].length; x++) {
        const result = this.hooks[id][x](...params);

        if (result) {
          results.push(result);
        }
      }
    }

    return results;
  }
}
