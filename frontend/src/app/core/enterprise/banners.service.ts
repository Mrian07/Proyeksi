

import { Inject, Injectable } from '@angular/core';
import { DOCUMENT } from '@angular/common';
import { enterpriseEditionUrl } from 'core-app/core/setup/globals/constants.const';

@Injectable({ providedIn: 'root' })
export class BannersService {
  private readonly _banners:boolean = true;

  constructor(@Inject(DOCUMENT) protected documentElement:Document) {
    this._banners = documentElement.body.classList.contains('ee-banners-visible');
  }

  public get eeShowBanners():boolean {
    return this._banners;
  }

  public getEnterPriseEditionUrl({ referrer, hash }:{ referrer?:string, hash?:string } = {}) {
    const url = new URL(enterpriseEditionUrl);
    if (referrer) {
      url.searchParams.set('op_referrer', referrer);
    }

    if (hash) {
      url.hash = hash;
    }

    return url.toString();
  }

  public conditional(bannersVisible?:() => void, bannersNotVisible?:() => void) {
    this._banners ? this.callMaybe(bannersVisible) : this.callMaybe(bannersNotVisible);
  }

  private callMaybe(func?:Function) {
    func && func();
  }
}
