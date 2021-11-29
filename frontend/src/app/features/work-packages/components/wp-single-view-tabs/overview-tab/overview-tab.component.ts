

import { Component } from '@angular/core';
import { StateService } from '@uirouter/core';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

@Component({
  templateUrl: './overview-tab.html',
  selector: 'wp-overview-tab',
})
export class WorkPackageOverviewTabComponent extends UntilDestroyedMixin {
  public workPackageId:string;

  public workPackage:WorkPackageResource;

  public tabName = this.I18n.t('js.label_latest_activity');

  public constructor(readonly I18n:I18nService,
    readonly $state:StateService,
    readonly apiV3Service:APIV3Service) {
    super();

    this.workPackageId = this.$state.params.workPackageId;

    this
      .apiV3Service
      .work_packages
      .id(this.workPackageId)
      .requireAndStream()
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe((wp) => this.workPackage = wp);
  }
}
