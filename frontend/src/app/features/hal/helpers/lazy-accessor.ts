

import { HalResource } from 'core-app/features/hal/resources/hal-resource';

export namespace OpenprojectHalModuleHelpers {
  export function lazy(obj:HalResource,
    property:string,
    getter:{ ():any },
    setter?:{ (value:any):void }):void {
    if (_.isObject(obj)) {
      let done = false;
      let value:any;
      const config:any = {
        get() {
          if (!done) {
            value = getter();
            done = true;
          }
          return value;
        },
        set: ():void => undefined,

        configurable: true,
        enumerable: true,
      };

      if (setter) {
        config.set = (val:any) => {
          value = setter(val);
          done = true;
        };
      }

      Object.defineProperty(obj, property, config);
    }
  }
}
