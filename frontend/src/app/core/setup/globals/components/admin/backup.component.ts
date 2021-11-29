

import { HttpErrorResponse } from '@angular/common/http';
import {
  AfterViewInit, Component, ElementRef, Injector, ViewChild,
} from '@angular/core';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { ToastService } from 'core-app/shared/components/toaster/toast.service';
import { JobStatusModalComponent } from 'core-app/features/job-status/job-status-modal/job-status.modal';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { OpenProjectBackupService } from 'core-app/core/backup/op-backup.service';

export const backupSelector = 'backup';

@Component({
  selector: backupSelector,
  templateUrl: './backup.component.html',
})
export class BackupComponent implements AfterViewInit {
  public text = {
    info: this.i18n.t('js.backup.info'),
    note: this.i18n.t('js.backup.note'),
    title: this.i18n.t('js.backup.title'),
    lastBackup: this.i18n.t('js.backup.last_backup'),
    lastBackupFrom: this.i18n.t('js.backup.last_backup_from'),
    includeAttachments: this.i18n.t('js.backup.include_attachments'),
    options: this.i18n.t('js.backup.options'),
    downloadBackup: this.i18n.t('js.backup.download_backup'),
    requestBackup: this.i18n.t('js.backup.request_backup'),
    attachmentsDisabled: this.i18n.t('js.backup.attachments_disabled'),
  };

  public jobStatusId:string = this.elementRef.nativeElement.dataset.jobStatusId;

  public lastBackupDate:string = this.elementRef.nativeElement.dataset.lastBackupDate;

  public lastBackupAttachmentId:string = this.elementRef.nativeElement.dataset.lastBackupAttachmentId;

  public mayIncludeAttachments:boolean = this.elementRef.nativeElement.dataset.mayIncludeAttachments != 'false';

  public isInProgress = false;

  public includeAttachments = true;

  public backupToken = '';

  @InjectField() opBackup:OpenProjectBackupService;

  @ViewChild('backupTokenInput') backupTokenInput:ElementRef;

  constructor(
    readonly elementRef:ElementRef,
    public injector:Injector,
    protected i18n:I18nService,
    protected toastService:ToastService,
    protected opModalService:OpModalService,
    protected pathHelper:PathHelperService,
  ) {
    this.includeAttachments = this.mayIncludeAttachments;
  }

  ngAfterViewInit() {
    this.backupTokenInput.nativeElement.focus();
  }

  public isDownloadReady():boolean {
    return this.jobStatusId !== undefined && this.jobStatusId !== ''
      && this.lastBackupAttachmentId !== undefined && this.lastBackupAttachmentId !== '';
  }

  public getDownloadUrl():string {
    return this.pathHelper.attachmentDownloadPath(this.lastBackupAttachmentId, undefined);
  }

  public includeAttachmentsDefault():boolean {
    return this.mayIncludeAttachments;
  }

  public includeAttachmentsTitle():string {
    return this.mayIncludeAttachments ? '' : this.text.attachmentsDisabled;
  }

  public triggerBackup(event?:JQuery.TriggeredEvent) {
    if (event) {
      event.stopPropagation();
      event.preventDefault();
    }

    const { backupToken } = this;

    this.backupToken = '';

    this.opBackup
      .triggerBackup(backupToken, this.includeAttachments)
      .toPromise()
      .then((resp:any) => {
        this.jobStatusId = resp.jobStatusId;
        this.opModalService.show(JobStatusModalComponent, 'global', { jobId: resp.jobStatusId });
      })
      .catch((error:HttpErrorResponse) => {
        this.toastService.addError(error.error);
      });
  }
}
