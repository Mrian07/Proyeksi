

import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, ElementRef, Inject, OnInit,
} from '@angular/core';
import { OpModalComponent } from 'core-app/shared/components/modal/modal.component';
import { OpModalLocalsToken, OpModalService } from 'core-app/shared/components/modal/modal.service';
import { OpModalLocalsMap } from 'core-app/shared/components/modal/modal.types';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import idFromLink from 'core-app/features/hal/helpers/id-from-link';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { StateService } from '@uirouter/core';

@Component({
  templateUrl: './wp-preview.modal.html',
  styleUrls: ['./wp-preview.modal.sass'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class WpPreviewModalComponent extends OpModalComponent implements OnInit {
  public workPackage:WorkPackageResource;

  public text = {
    created_by: this.i18n.t('js.label_created_by'),
  };

  constructor(readonly elementRef:ElementRef,
    @Inject(OpModalLocalsToken) readonly locals:OpModalLocalsMap,
    readonly cdRef:ChangeDetectorRef,
    readonly i18n:I18nService,
    readonly apiV3Service:APIV3Service,
    readonly opModalService:OpModalService,
    readonly $state:StateService) {
    super(locals, cdRef, elementRef);
  }

  ngOnInit() {
    super.ngOnInit();
    const { workPackageLink } = this.locals;
    const workPackageId = idFromLink(workPackageLink);

    this
      .apiV3Service
      .work_packages
      .id(workPackageId)
      .requireAndStream()
      .subscribe((workPackage:WorkPackageResource) => {
        this.workPackage = workPackage;
        this.cdRef.detectChanges();

        const modal = jQuery(this.elementRef.nativeElement).find('.op-wp-preview-modal');
        this.reposition(modal, this.locals.event.target);
      });
  }

  public reposition(element:JQuery<HTMLElement>, target:JQuery<HTMLElement>) {
    element.position({
      my: 'right top',
      at: 'right bottom',
      of: target,
      collision: 'flipfit',
    });
  }

  public openStateLink(event:{ workPackageId:string; requestedState:string }) {
    const params = { workPackageId: event.workPackageId };

    this.$state.go(event.requestedState, params);
  }
}
