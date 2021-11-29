

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { HTTPSupportedMethods } from 'core-app/features/hal/http/http.interfaces';
import { HalResourceService } from 'core-app/features/hal/services/hal-resource.service';

export interface HalLinkInterface {
  href:string|null;
  method:HTTPSupportedMethods;
  title?:string;
  templated?:boolean;
  payload?:any;
  type?:string;
  identifier?:string;
}

export interface HalLinkSource {
  href:string|null;
  title:string;
}

export interface CallableHalLink extends HalLinkInterface {
  $link:this;
  data?:Promise<HalResource>;
}

export class HalLink implements HalLinkInterface {
  constructor(public requestMethod:(method:HTTPSupportedMethods, href:string, data:any, headers:any) => Promise<HalResource>,
    public href:string|null = null,
    public title:string = '',
    public method:HTTPSupportedMethods = 'get',
    public templated:boolean = false,
    public payload?:any,
    public type:string = 'application/json',
    public identifier?:string) {
  }

  /**
   * Create the HalLink from an object with the HalLinkInterface.
   */
  public static fromObject(halResourceService:HalResourceService, link:HalLinkInterface):HalLink {
    return new HalLink(
      (method:HTTPSupportedMethods, href:string, data:any, headers:any) => halResourceService.request(method, href, data, headers).toPromise(),
      link.href,
      link.title,
      link.method,
      link.templated,
      link.payload,
      link.type,
      link.identifier,
    );
  }

  /**
   * Fetch the resource.
   */
  public $fetch(...params:any[]):Promise<HalResource> {
    const [data, headers] = params;
    return this.requestMethod(this.method, this.href as string, data, headers);
  }

  /**
   * Prepare the templated link and return a CallableHalLink with the templated parameters set
   *
   * @returns {CallableHalLink}
   */
  public $prepare(templateValues:{ [templateKey:string]:string }) {
    if (!this.templated) {
      throw new Error(`The link ${this.href} is not templated.`);
    }

    let href = _.clone(this.href) || '';
    _.each(templateValues, (value:string, key:string) => {
      const regexp = new RegExp(`{${key}}`);
      href = href.replace(regexp, value);
    });

    return new HalLink(
      this.requestMethod,
      href,
      this.title,
      this.method,
      false,
      this.payload,
      this.type,
      this.identifier,
    ).$callable();
  }

  /**
   * Return a function that fetches the resource.
   *
   * @returns {CallableHalLink}
   */
  public $callable():CallableHalLink {
    const linkFunc:any = (...params:any[]) => this.$fetch(...params);

    _.extend(linkFunc, {
      $link: this,
      href: this.href,
      title: this.title,
      method: this.method,
      templated: this.templated,
      payload: this.payload,
      type: this.type,
      identifier: this.identifier,
    });

    return linkFunc;
  }
}
