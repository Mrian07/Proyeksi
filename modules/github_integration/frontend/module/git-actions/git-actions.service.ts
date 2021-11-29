

import { Injectable } from '@angular/core';
import { WorkPackageResource } from "core-app/features/hal/resources/work-package-resource";

// probably not providable in root when we want to cache the formatter and set custom templates
@Injectable({
  providedIn: 'root',
})
export class GitActionsService {
  private sanitizeBranchString(str:string):string {
    // See https://stackoverflow.com/a/3651867 for how these rules came in.
    // This sanitization tries to be harsher than those rules
    return str
      .replace(/&/g, 'and ') // & becomes and
      .replace(/ +/g, '-') // Spaces become dashes
      .replace(/[\000-\039]/g, '') // ASCII control characters are out
      .replace(/\177/g, '') // DEL is out
      .replace(/[#\\\/\?\*\~\^\:\{\}@\.\[\]'"]/g, '') // Some other characters with special rules are out
      .replace(/^[-]+/g, '') // Dashes at the start are removed
      .replace(/[-]+$/g, '') // Dashes at the end are removed
      .replace(/-+/g, '-') // Multiple dashes in a row are deduped
      .trim();
  }

  private formattingInput(workPackage: WorkPackageResource) {
    const type = workPackage.type.name || '';
    const id = workPackage.id || '';
    const title = workPackage.subject;
    const url = window.location.origin + workPackage.pathHelper.workPackagePath(id);
    const description = '';

    return({
      id, type, title, url, description
    });
  }

  private sanitizeShellInput(str:string):string {
    return `${str.replace(/'/g, '\\\'')}`;
  }

  public branchName(workPackage:WorkPackageResource):string {
    const { type, id, title } = this.formattingInput(workPackage);
    return `${this.sanitizeBranchString(type)}/${id}-${this.sanitizeBranchString(title)}`.toLocaleLowerCase();
  }

  public commitMessage(workPackage:WorkPackageResource):string {
    const { title, id, description, url } = this.formattingInput(workPackage);
    return `[#${id}] ${title}

${description}

${url}
`.replace(/\n\n+/g, '\n\n');
  }

  public gitCommand(workPackage:WorkPackageResource):string {
    const branch = this.branchName(workPackage);
    const commit = this.commitMessage(workPackage);
    return `git checkout -b '${this.sanitizeShellInput(branch)}' && git commit --allow-empty -m '${this.sanitizeShellInput(commit)}'`;
  }
}
