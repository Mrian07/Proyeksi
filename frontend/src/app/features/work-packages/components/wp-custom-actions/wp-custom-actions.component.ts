

import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, OnInit,
} from '@angular/core';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { CustomActionResource } from 'core-app/features/hal/resources/custom-action-resource';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';

@Component({
  selector: 'wp-custom-actions',
  templateUrl: './wp-custom-actions.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class WpCustomActionsComponent extends UntilDestroyedMixin implements OnInit {
  @Input() workPackage:WorkPackageResource;

  actions:CustomActionResource[] = [];

  constructor(readonly apiV3Service:APIV3Service,
    readonly cdRef:ChangeDetectorRef) {
    super();
  }

  ngOnInit() {
    this
      .apiV3Service
      .work_packages
      .id(this.workPackage.id!)
      .requireAndStream()
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe((wp) => {
        this.actions = wp.customActions ? [...wp.customActions] : [];
        this.cdRef.detectChanges();
      });
  }
}
