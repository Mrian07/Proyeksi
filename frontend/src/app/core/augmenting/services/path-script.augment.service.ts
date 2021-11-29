

import { Inject, Injectable } from '@angular/core';
import { DOCUMENT } from '@angular/common';
import { debugLog } from 'core-app/shared/helpers/debug_output';

@Injectable({ providedIn: 'root' })
export class PathScriptAugmentService {
  constructor(@Inject(DOCUMENT) protected documentElement:Document) {
  }

  /**
   * Import required javascript paths from backend-rendered pages
   * This provides a replacement for the asset pipeline that was previously used
   * to load javascripts in the backend.
   *
   * This approach retains the ability to dynamically load code (from a specific set of paths only)
   * while defining the dependency in the rails template to ensure developer visibility.
   */
  public loadRequiredScripts() {
    const matches = this.documentElement.querySelectorAll<HTMLMetaElement>('meta[name="required_script"]');
    for (let i = 0; i < matches.length; ++i) {
      const name = matches[i].content;
      debugLog(`Loading required script ${name}`);
      import(`../dynamic-scripts/${name}`);
    }
  }
}
