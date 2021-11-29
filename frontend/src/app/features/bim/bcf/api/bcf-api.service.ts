

import { Injectable, Injector } from '@angular/core';
import { BcfResourceCollectionPath } from 'core-app/features/bim/bcf/api/bcf-path-resources';
import { BcfProjectPaths } from 'core-app/features/bim/bcf/api/projects/bcf-project.paths';

@Injectable({ providedIn: 'root' })
export class BcfApiService {
  public readonly bcfApiVersion = '2.1';

  public readonly appBasePath = window.appBasePath || '';

  public readonly bcfApiBase = `${this.appBasePath}/api/bcf/${this.bcfApiVersion}`;

  // /api/bcf/:version/projects
  public readonly projects = new BcfResourceCollectionPath(this.injector, this.bcfApiBase, 'projects', BcfProjectPaths);

  constructor(readonly injector:Injector) {
  }

  /**
   * Parse the given string into a BCF resource path
   *
   * @param href
   */
  parse<T>(href:string):T {
    if (!href.startsWith(this.bcfApiBase)) {
      throw new Error(`Cannot parse ${href} into BCF resource.`);
    }

    const parts = href
      .replace(`${this.bcfApiBase}/`, '')
      .split('/');

    // Try to find a target collection or resource
    let current:any = this;

    for (let i = 0; i < parts.length; i++) {
      const pathOrId:string = parts[i];
      if (pathOrId in current) {
        // Current has a member named like this URL part
        // descend into it
        current = current[pathOrId];
      } else if (current instanceof BcfResourceCollectionPath) {
        // Otherwise, assume we're looking for an ID
        current = current.id(pathOrId);
      } else {
        // Otherwise, return the current
        break;
      }
    }

    return current === this ? undefined : current;
  }
}
