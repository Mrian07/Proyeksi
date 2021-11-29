

import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, OnInit,
} from '@angular/core';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { IToast, ToastService } from './toast.service';

export const toastsContainerSelector = 'op-toasts-container';

@Component({
  template: `
    <div class="op-toast--wrapper">
      <div class="op-toast--casing">
        <op-toast [toast]="toast" *ngFor="let toast of stack"></op-toast>
      </div>
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: toastsContainerSelector,
})
export class ToastsContainerComponent extends UntilDestroyedMixin implements OnInit {
  public stack:IToast[] = [];

  constructor(
    readonly toastService:ToastService,
    readonly cdRef:ChangeDetectorRef
  ) {
    super();
  }

  ngOnInit():void {
    this.toastService
      .current
      .values$('Subscribing to changes in the toaster stack')
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe((stack) => {
        this.stack = stack;
        this.cdRef.detectChanges();
      });
  }
}
