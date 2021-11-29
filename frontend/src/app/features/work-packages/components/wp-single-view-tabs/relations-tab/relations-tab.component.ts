

import { Transition } from '@uirouter/core';
import { Component, Input, OnInit } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

@Component({
  templateUrl: './relations-tab.html',
  selector: 'wp-relations-tab',
})
export class WorkPackageRelationsTabComponent extends UntilDestroyedMixin implements OnInit {
  @Input() public workPackageId?:string;

  public workPackage:WorkPackageResource;

  public constructor(readonly I18n:I18nService,
    readonly $transition:Transition,
    readonly apiV3Service:APIV3Service) {
    super();
  }

  ngOnInit() {
    const wpId = this.workPackageId || this.$transition.params('to').workPackageId;
    this
      .apiV3Service
      .work_packages
      .id(wpId)
      .requireAndStream()
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe((wp) => {
        this.workPackageId = wp.id!;
        this.workPackage = wp;
      });
  }
}
