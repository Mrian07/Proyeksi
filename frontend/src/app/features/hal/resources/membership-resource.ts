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
