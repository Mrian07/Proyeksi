

import { StateService } from '@uirouter/core';
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { UrlParamsHelperService } from 'core-app/features/work-packages/components/wp-query/url-params-helper';
import { ToastService } from 'core-app/shared/components/toaster/toast.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { HalDeletedEvent, HalEventsService } from 'core-app/features/hal/services/hal-events.service';

@Injectable()
export class WorkPackageService {
  private text = {
    successful_delete: this.I18n.t('js.work_packages.message_successful_bulk_delete'),
  };

  constructor(private readonly http:HttpClient,
    private readonly $state:StateService,
    private readonly PathHelper:PathHelperService,
    private readonly UrlParamsHelper:UrlParamsHelperService,
    private readonly toastService:ToastService,
    private readonly I18n:I18nService,
    private readonly halEvents:HalEventsService) {
  }

  public performBulkDelete(ids:string[], defaultHandling:boolean) {
    const params = {
      'ids[]': ids,
    };
    const promise = this.http
      .delete(
        this.PathHelper.workPackagesBulkDeletePath(),
        { params, withCredentials: true },
      )
      .toPromise();

    if (defaultHandling) {
      promise
        .then(() => {
          this.toastService.addSuccess(this.text.successful_delete);

          ids.forEach((id) => this.halEvents.push({ _type: 'WorkPackage', id }, { eventType: 'deleted' } as HalDeletedEvent));

          if (this.$state.includes('**.list.details.**')
            && ids.indexOf(this.$state.params.workPackageId) > -1) {
            this.$state.go('work-packages.partitioned.list', this.$state.params);
          }
        })
        .catch(() => {
          const urlParams = this.UrlParamsHelper.buildQueryString(params);
          window.location.href = `${this.PathHelper.workPackagesBulkDeletePath()}?${urlParams}`;
        });
    }

    return promise;
  }
}
