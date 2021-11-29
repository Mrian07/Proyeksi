

import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, EventEmitter, Output,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { EditFormComponent } from 'core-app/shared/components/fields/edit/edit-form/edit-form.component';

@Component({
  templateUrl: './wp-edit-actions-bar.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'wp-edit-actions-bar',
})
export class WorkPackageEditActionsBarComponent {
  @Output('onSave') public onSave = new EventEmitter<void>();

  @Output('onCancel') public onCancel = new EventEmitter<void>();

  public _saving = false;

  public text = {
    save: this.I18n.t('js.button_save'),
    cancel: this.I18n.t('js.button_cancel'),
  };

  constructor(private I18n:I18nService,
    private editForm:EditFormComponent,
    private cdRef:ChangeDetectorRef) {
  }

  public set saving(active:boolean) {
    this._saving = active;
    this.cdRef.detectChanges();
  }

  public get saving() {
    return this._saving;
  }

  public save():void {
    if (this.saving) {
      return;
    }

    this.saving = true;
    this.editForm
      .submit()
      .then(() => {
        this.saving = false;
        this.onSave.emit();
      })
      .catch(() => {
        this.saving = false;
      });
  }

  public cancel():void {
    this.editForm.cancel();
    this.onCancel.emit();
  }
}
