

import { Component, HostListener, Input } from '@angular/core';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { HalResourceService } from 'core-app/features/hal/services/hal-resource.service';
import { WorkPackagesActivityService } from 'core-app/features/work-packages/components/wp-single-view-tabs/activity-panel/wp-activity.service';
import { HalResourceEditingService } from 'core-app/shared/components/fields/edit/services/hal-resource-editing.service';
import { SchemaCacheService } from 'core-app/core/schemas/schema-cache.service';
import { HalEventsService } from 'core-app/features/hal/services/hal-events.service';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { CustomActionResource } from 'core-app/features/hal/resources/custom-action-resource';

@Component({
  selector: 'wp-custom-action',
  templateUrl: './wp-custom-action.component.html',
})
export class WpCustomActionComponent {
  @Input() workPackage:WorkPackageResource;

  @Input() action:CustomActionResource;

  constructor(private halResourceService:HalResourceService,
    private apiV3Service:APIV3Service,
    private wpSchemaCacheService:SchemaCacheService,
    private wpActivity:WorkPackagesActivityService,
    private notificationService:WorkPackageNotificationService,
    private halEditing:HalResourceEditingService,
    private halEvents:HalEventsService) {
  }

  private fetchAction() {
    this.halResourceService.get<CustomActionResource>(this.action.href!)
      .toPromise()
      .then((action) => {
        this.action = action;
      });
  }

  public update() {
    const payload = {
      lockVersion: this.workPackage.lockVersion,
      _links: {
        workPackage: {
          href: this.workPackage.href,
        },
      },
    };

    this.halResourceService
      .post<WorkPackageResource>(`${this.action.href}/execute`, payload)
      .subscribe(
        (savedWp:WorkPackageResource) => {
          this.notificationService.showSave(savedWp, false);
          this.workPackage = savedWp;
          this.wpActivity.clear(this.workPackage.id);
          // Loading the schema might be necessary in cases where the button switches
          // project or type.
          this.apiV3Service.work_packages.cache.updateWorkPackage(savedWp).then(() => {
            this.halEditing.stopEditing(savedWp);
            this.halEvents.push(savedWp, { eventType: 'updated' });
          });
        },
        (errorResource:any) => this.notificationService.handleRawError(errorResource, this.workPackage),
      );
  }

  @HostListener('mouseenter') onMouseEnter() {
    this.fetchAction();
  }
}
