

import { Component, Input, OnInit } from '@angular/core';
import { UIRouterGlobals } from '@uirouter/core';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { randomString } from 'core-app/shared/helpers/random-string';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

@Component({
  selector: 'wp-subject',
  templateUrl: './wp-subject.html',
})
export class WorkPackageSubjectComponent extends UntilDestroyedMixin implements OnInit {
  @Input('workPackage') workPackage:WorkPackageResource;

  public readonly uniqueElementIdentifier = `work-packages--subject-type-row-${randomString(16)}`;

  constructor(protected uiRouterGlobals:UIRouterGlobals,
    protected apiV3Service:APIV3Service) {
    super();
  }

  ngOnInit() {
    if (!this.workPackage) {
      this
        .apiV3Service
        .work_packages
        .id(this.uiRouterGlobals.params.workPackageId)
        .requireAndStream()
        .pipe(
          this.untilDestroyed(),
        )
        .subscribe((wp:WorkPackageResource) => {
          this.workPackage = wp;
        });
    }
  }
}
