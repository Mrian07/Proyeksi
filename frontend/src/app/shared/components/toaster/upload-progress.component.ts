

import {
  Component, ElementRef, EventEmitter, Input, OnInit, Output, ViewChild,
} from '@angular/core';
import { HttpErrorResponse, HttpEventType, HttpProgressEvent } from '@angular/common/http';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { debugLog } from 'core-app/shared/helpers/debug_output';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { UploadFile, UploadHttpEvent, UploadInProgress } from 'core-app/core/file-upload/op-file-upload.service';

@Component({
  selector: 'op-toasters-upload-progress',
  template: `
    <li>
      <span class="filename" [textContent]="fileName"></span>
      <progress max="100" value="0" #progressBar></progress>
      <p #progressPercentage>0%</p>
      <span class="upload-completed" *ngIf="completed || error">
      <op-icon icon-classes="icon-close" *ngIf="error"></op-icon>
      <op-icon icon-classes="icon-checkmark" *ngIf="completed"></op-icon>
    </span>
    </li>
  `,
})
export class UploadProgressComponent extends UntilDestroyedMixin implements OnInit {
  @Input() public upload:UploadInProgress;

  @Output() public onError = new EventEmitter<HttpErrorResponse>();

  @Output() public onSuccess = new EventEmitter<undefined>();

  @ViewChild('progressBar')
  progressBar:ElementRef;

  @ViewChild('progressPercentage')
  progressPercentage:ElementRef;

  public file:UploadFile;

  public error = false;

  public completed = false;

  set value(value:number) {
    this.progressBar.nativeElement.value = value;
    this.progressPercentage.nativeElement.innerText = `${value}%`;

    if (value === 100) {
      this.progressBar.nativeElement.style.display = 'none';
    }
  }

  constructor(protected readonly I18n:I18nService) {
    super();
  }

  ngOnInit() {
    this.file = this.upload[0];
    const observable = this.upload[1];

    observable
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe(
        (evt:UploadHttpEvent) => {
          switch (evt.type) {
            case HttpEventType.Sent:
              this.value = 5;
              return debugLog(`Uploading file "${this.file.name}" of size ${this.file.size}.`);

            case HttpEventType.UploadProgress:
              return this.updateProgress(evt);

            case HttpEventType.Response:
              debugLog(`File ${this.fileName} was fully uploaded.`);
              this.value = 100;
              this.completed = true;
              return this.onSuccess.emit();

            default:
            // Sent or unknown event
          }
        },
        (error:HttpErrorResponse) => this.handleError(error),
      );
  }

  public get fileName():string|undefined {
    return this.file && this.file.name;
  }

  private updateProgress(evt:HttpProgressEvent) {
    if (evt.total) {
      this.value = Math.round(evt.loaded / evt.total * 100);
    } else {
      this.value = 10;
    }
  }

  private handleError(error:HttpErrorResponse) {
    this.error = true;
    this.onError.emit(error);
  }
}
