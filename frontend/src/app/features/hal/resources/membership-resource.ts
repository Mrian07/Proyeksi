

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { RoleResource } from 'core-app/features/hal/resources/role-resource';
import { ProjectResource } from 'core-app/features/hal/resources/project-resource';
import Formattable = api.v3.Formattable;

export interface MembershipResourceLinks {
  update(payload:unknown):Promise<unknown>;
  updateImmediately(payload:unknown):Promise<unknown>;
  delete():Promise<unknown>;
}

export interface MembershipResourceEmbedded {
  principal:HalResource;
  roles:RoleResource[];
  project:ProjectResource;
  notificationMessage:Formattable;
}

export class MembershipResource extends HalResource {
}

export interface MembershipResource extends MembershipResourceLinks, MembershipResourceEmbedded {}
