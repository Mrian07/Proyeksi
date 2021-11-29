

import { Injectable } from '@angular/core';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

@Injectable({ providedIn: 'root' })
export class CurrentProjectService {
  private current:{ id:string, identifier:string, name:string };

  constructor(
    private PathHelper:PathHelperService,
    private apiV3Service:APIV3Service,
  ) {
    this.detect();
  }

  public get inProjectContext():boolean {
    return this.current !== undefined;
  }

  public get path():string|null {
    if (this.current) {
      return this.PathHelper.projectPath(this.current.identifier);
    }

    return null;
  }

  public get apiv3Path():string|null {
    if (this.current) {
      return this.apiV3Service.projects.id(this.current.id).toString();
    }

    return null;
  }

  public get id():string|null {
    return this.getCurrent('id');
  }

  public get name():string|null {
    return this.getCurrent('name');
  }

  public get identifier():string|null {
    return this.getCurrent('identifier');
  }

  private getCurrent(key:'id'|'identifier'|'name') {
    if (this.current && this.current[key]) {
      return this.current[key].toString();
    }

    return null;
  }

  /**
   * Detect the current project from its meta tag.
   */
  public detect() {
    const element:HTMLMetaElement|null = document.querySelector('meta[name=current_project]');
    if (element) {
      this.current = {
        id: element.dataset.projectId!,
        name: element.dataset.projectName!,
        identifier: element.dataset.projectIdentifier!,
      };
    }
  }
}
