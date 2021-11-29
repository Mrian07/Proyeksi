

import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { StateService } from '@uirouter/core';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';

export class WorkPackageAuthorization {
  public project:any;

  constructor(public workPackage:WorkPackageResource,
    readonly PathHelper:PathHelperService,
    readonly $state:StateService) {
    this.project = workPackage.project;
  }

  public get allActions():any {
    return {
      workPackage: this.workPackage,
      project: this.project,
    };
  }

  public copyLink() {
    const stateName = this.$state.current.name as string;
    if (stateName.indexOf('work-packages.partitioned.list.details') === 0) {
      return this.PathHelper.workPackageDetailsCopyPath(this.project.identifier, this.workPackage.id!);
    }
    return this.PathHelper.workPackageCopyPath(this.workPackage.id!);
  }

  public linkForAction(action:any) {
    if (action.key === 'copy') {
      action.link = this.copyLink();
    } else {
      action.link = this.allActions[action.resource][action.link].href;
    }

    return action;
  }

  public isPermitted(action:any) {
    return this.allActions[action.resource] !== undefined
      && this.allActions[action.resource][action.link] !== undefined;
  }

  public permittedActionKeys(allowedActions:any) {
    const validActions = _.filter(allowedActions, (action:any) => this.isPermitted(action));

    return _.map(validActions, (action:any) => action.key);
  }

  public permittedActionsWithLinks(allowedActions:any) {
    const validActions = _.filter(_.cloneDeep(allowedActions), (action:any) => this.isPermitted(action));

    const allowed = _.map(validActions, (action:any) => this.linkForAction(action));

    return allowed;
  }
}
