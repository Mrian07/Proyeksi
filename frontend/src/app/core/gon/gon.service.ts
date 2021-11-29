

import { Injectable } from '@angular/core';
import { IFCGonDefinition } from '../../features/bim/ifc_models/pages/viewer/ifc-models-data.service';

declare global {
  interface Window {
    gon:GonType;
  }
}

export interface GonType {
  [key:string]:unknown;
  ifc_models:IFCGonDefinition;
}

@Injectable({ providedIn: 'root' })
export class GonService {
  get(...path:string[]):unknown|null {
    return _.get(window.gon, path, null);
  }

  /**
   * Get the gon object
   */
  get gon():GonType {
    return window.gon;
  }
}
