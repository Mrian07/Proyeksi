

import { Injectable } from '@angular/core';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { HalLink } from 'core-app/features/hal/hal-link/hal-link';

@Injectable()
export class BcfPathHelperService {
  constructor(readonly pathHelper:PathHelperService) {
  }

  public projectImportIssuePath(projectIdentifier:string) {
    return `${this.pathHelper.projectPath(projectIdentifier)}/issues/upload`;
  }

  public projectExportIssuesPath(projectIdentifier:string, filters:string|null) {
    if (filters) {
      return `${this.pathHelper.projectPath(projectIdentifier)}/work_packages.bcf?filters=${filters}`;
    }
    return `${this.pathHelper.projectPath(projectIdentifier)}/work_packages.bcf`;
  }

  public snapshotPath(viewpoint:HalLink) {
    return `${viewpoint.href}/snapshot`;
  }
}
