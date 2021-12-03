// -- copyright
// ProyeksiApp is an open source project management software.
// Copyright (C) 2012-2021 the ProyeksiApp GmbH
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License version 3.
//
// ProyeksiApp is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
// Copyright (C) 2006-2013 Jean-Philippe Lang
// Copyright (C) 2010-2013 the ChiliProject Team
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
//
// See COPYRIGHT and LICENSE files for more details.
//++

import { HalResource } from 'core-app/features/hal/resources/hal-resource';

export namespace ProyeksiappHalModuleHelpers {
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
