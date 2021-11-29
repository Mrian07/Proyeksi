

import { Injectable } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { ToastService } from 'core-app/shared/components/toaster/toast.service';
import { Subject } from 'rxjs';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';

@Injectable()
export class CommentService {
  // Replacement for ng1 $scope.$emit on activty-entry to mark comments to be quoted.
  // Should be generalized if needed for more than that.
  public quoteEvents = new Subject<string>();

  constructor(
    readonly I18n:I18nService,
    private workPackageNotificationService:WorkPackageNotificationService,
    private toastService:ToastService,
  ) {
  }

  public createComment(workPackage:WorkPackageResource, comment:{ raw:string }) {
    return workPackage.addComment(
      { comment },
      { 'Content-Type': 'application/json; charset=UTF-8' },
    )
      .catch((error:any) => this.errorAndReject(error, workPackage));
  }

  public updateComment(activity:HalResource, comment:string) {
    const options = {
      ajax: {
        method: 'PATCH',
        data: JSON.stringify({ comment }),
        contentType: 'application/json; charset=utf-8',
      },
    };

    return activity.update(
      { comment },
      { 'Content-Type': 'application/json; charset=UTF-8' },
    ).then((activity:HalResource) => {
      this.toastService.addSuccess(
        this.I18n.t('js.work_packages.comment_updated'),
      );

      return activity;
    }).catch((error:any) => this.errorAndReject(error));
  }

  private errorAndReject(error:HalResource, workPackage?:WorkPackageResource) {
    this.workPackageNotificationService.handleRawError(error, workPackage);

    // returning a reject will enable to correctly work with subsequent then/catch handlers.
    return Promise.reject(error);
  }
}
