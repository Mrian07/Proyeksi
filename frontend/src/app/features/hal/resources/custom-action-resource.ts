

import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';

export interface CustomActionResourceLinks {
  self():Promise<CustomActionResource>;
  executeImmediately(payload:any):Promise<WorkPackageResource>;
}

export interface CustomActionResourceEmbedded {
  description:string;
}

export class CustomActionResource extends HalResource {
}

export interface CustomActionResource extends CustomActionResourceLinks, CustomActionResourceEmbedded {}
