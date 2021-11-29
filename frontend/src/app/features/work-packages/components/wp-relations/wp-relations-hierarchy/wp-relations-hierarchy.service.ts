

import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { States } from 'core-app/core/states/states.service';
import { StateService } from '@uirouter/core';
import { Injectable } from '@angular/core';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { HalEventsService } from 'core-app/features/hal/services/hal-events.service';

@Injectable()
export class WorkPackageRelationsHierarchyService {
  constructor(protected $state:StateService,
    protected states:States,
    protected halEvents:HalEventsService,
    protected notificationService:WorkPackageNotificationService,
    protected pathHelper:PathHelperService,
    protected apiV3Service:APIV3Service) {

  }

  public changeParent(workPackage:WorkPackageResource, parentId:string|null) {
    const payload:any = {
      lockVersion: workPackage.lockVersion,
    };

    if (parentId) {
      payload._links = {
        parent: {
          href: this.apiV3Service.work_packages.id(parentId).path,
        },
      };
    } else {
      payload._links = {
        parent: {
          href: null,
        },
      };
    }

    return workPackage
      .changeParent(payload)
      .then((wp:WorkPackageResource) => {
        this
          .apiV3Service
          .work_packages
          .cache
          .updateWorkPackage(wp);
        this.notificationService.showSave(wp);
        this.halEvents.push(workPackage, {
          eventType: 'association',
          relatedWorkPackage: parentId,
          relationType: 'parent',
        });

        return wp;
      })
      .catch((error) => {
        this.notificationService.handleRawError(error, workPackage);
        return Promise.reject(error);
      });
  }

  public removeParent(workPackage:WorkPackageResource) {
    return this.changeParent(workPackage, null);
  }

  public addExistingChildWp(workPackage:WorkPackageResource, childWpId:string):Promise<WorkPackageResource> {
    return this
      .apiV3Service
      .work_packages
      .id(childWpId)
      .get()
      .toPromise()
      .then((wpToBecomeChild:WorkPackageResource|undefined) => this.changeParent(wpToBecomeChild!, workPackage.id)
        .then((wp) => {
          // Reload work package
          this
            .apiV3Service
            .work_packages
            .id(workPackage)
            .refresh();

          this.halEvents.push(workPackage, {
            eventType: 'association',
            relatedWorkPackage: wpToBecomeChild!.id!,
            relationType: 'child',
          });

          return wp;
        }));
  }

  public addNewChildWp(baseRoute:string, workPackage:WorkPackageResource) {
    workPackage.project.$load()
      .then(() => {
        const args = [
          `${baseRoute}.new`,
          {
            parent_id: workPackage.id,
          },
        ];

        if (this.$state.includes('work-packages.show')) {
          args[0] = 'work-packages.new';
        }

        (<any> this.$state).go(...args);
      });
  }

  public removeChild(childWorkPackage:WorkPackageResource) {
    return childWorkPackage.$load().then(() => {
      const parentWorkPackage = childWorkPackage.parent;
      return childWorkPackage.changeParent({
        _links: {
          parent: {
            href: null,
          },
        },
        lockVersion: childWorkPackage.lockVersion,
      }).then((wp) => {
        if (parentWorkPackage) {
          this
            .apiV3Service
            .work_packages
            .id(parentWorkPackage)
            .refresh()
            .then((wp) => {
              this.halEvents.push(wp, {
                eventType: 'association',
                relatedWorkPackage: null,
                relationType: 'child',
              });
            });
        }

        this
          .apiV3Service
          .work_packages
          .cache
          .updateWorkPackage(wp);
      })
        .catch((error) => {
          this.notificationService.handleRawError(error, childWorkPackage);
          return Promise.reject(error);
        });
    });
  }
}
