

import { Injectable, SecurityContext } from '@angular/core';
import { DomSanitizer, SafeHtml } from '@angular/platform-browser';

@Injectable({ providedIn: 'root' })
export class HTMLSanitizeService {
  public constructor(readonly sanitizer:DomSanitizer) { }

  public sanitize(string:string):SafeHtml {
    return this.sanitizer.sanitize(SecurityContext.HTML, string) || '';
  }
}
