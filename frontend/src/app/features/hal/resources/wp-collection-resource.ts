

import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { CollectionResource } from 'core-app/features/hal/resources/collection-resource';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';

export interface WorkPackageCollectionResourceEmbedded {
  elements:WorkPackageResource[];
  groups:GroupObject[];
}

export class WorkPackageCollectionResource extends CollectionResource<WorkPackageResource> {
  public schemas:CollectionResource<SchemaResource>;

  public createWorkPackage:any;

  public elements:WorkPackageResource[];

  public groups:GroupObject[];

  public totalSums?:{ [key:string]:number };

  public sumsSchema?:SchemaResource;

  public representations:Array<HalResource>;
}

export interface WorkPackageCollectionResource extends WorkPackageCollectionResourceEmbedded {}

/**
 * A reference to a group object as returned from the API.
 * Augmented with state information such as collapsed state.
 */
export interface GroupObject {
  value:any;
  count:number;
  collapsed?:boolean;
  index:number;
  identifier:string;
  sums:{ [attribute:string]:number|null };
  href:{ href:string }[];
  _links:{
    valueLink:{ href:string }[];
    groupBy:{ href:string };
  };
}
