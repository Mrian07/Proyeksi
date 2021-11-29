

import {
  ChangeDetectionStrategy, Component, Input, OnInit,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import {
  IToast,
  ToastService,
  ToastType,
} from './toast.service';

@Component({
  templateUrl: './toast.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'op-toast',
})
export class ToastComponent implements OnInit {
  @Input() public toast:IToast;

  public text = {
    close_popup: this.I18n.t('js.close_popup_title'),
  };

  public type:ToastType;

  public uploadCount = 0;

  public show = false;

  constructor(readonly I18n:I18nService,
    readonly toastService:ToastService) {
  }

  ngOnInit() {
    this.type = this.toast.type;
  }

  public get data() {
    return this.toast.data;
  }

  public canBeHidden() {
    return this.data && this.data.length > 5;
  }

  public removable() {
    return this.toast.type !== 'upload';
  }

  public remove() {
    this.toastService.remove(this.toast);
  }

  /**
   * Execute the link callback from content.link.target
   * and close this toaster.
   */
  public executeTarget() {
    if (this.toast.link) {
      this.toast.link.target();
      this.remove();
    }
  }

  public onUploadError(message:string) {
    this.remove();
  }

  public onUploadSuccess() {
    this.uploadCount += 1;
  }

  public get uploadText() {
    return this.I18n.t('js.label_upload_counter',
      { done: this.uploadCount, count: this.data.length });
  }
}
