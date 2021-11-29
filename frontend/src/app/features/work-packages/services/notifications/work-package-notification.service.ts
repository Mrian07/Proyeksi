

import { Injectable, Injector } from '@angular/core';
import { IToast } from 'core-app/shared/components/toaster/toast.service';
import { HalResourceNotificationService } from 'core-app/features/hal/services/hal-resource-notification.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

@Injectable()
export class WorkPackageNotificationService extends HalResourceNotificationService {
  constructor(readonly injector:Injector,
    readonly apiV3Service:APIV3Service) {
    super(injector);
  }

  public showSave(resource:WorkPackageResource, isCreate = false) {
    const message:any = {
      message: this.I18n.t(`js.notice_successful_${isCreate ? 'create' : 'update'}`),
    };

    this.addWorkPackageFullscreenLink(message, resource as any);

    this.ToastService.addSuccess(message);
  }

  protected showCustomError(errorResource:any, resource:WorkPackageResource):boolean {
    if (errorResource.errorIdentifier === 'urn:openproject-org:api:v3:errors:UpdateConflict') {
      this.ToastService.addError({
        message: errorResource.message,
        type: 'error',
        link: {
          text: this.I18n.t('js.hal.error.update_conflict_refresh'),
          target: () => this.apiV3Service.work_packages.id(resource).refresh(),
        },
      });

      return true;
    }

    return super.showCustomError(errorResource, resource);
  }

  private addWorkPackageFullscreenLink(message:IToast, resource:WorkPackageResource) {
    // Don't show the 'Show in full screen' link  if we're there already
    if (!this.$state.includes('work-packages.show')) {
      message.link = {
        target: () => this.$state.go('work-packages.show.tabs', { tabIdentifier: 'activity', workPackageId: resource.id }),
        text: this.I18n.t('js.work_packages.message_successful_show_in_fullscreen'),
      };
    }
  }
}
