

import { Injectable } from '@angular/core';

@Injectable()
export class FirstRouteService {
  public name:string;

  public params:any;

  constructor() {}

  public get isEmpty() {
    return !this.name;
  }

  public setIfFirst(stateName:string|undefined, params:any) {
    if (!this.isEmpty || !stateName) {
      return;
    }

    this.name = stateName;
    this.params = params;
  }
}
