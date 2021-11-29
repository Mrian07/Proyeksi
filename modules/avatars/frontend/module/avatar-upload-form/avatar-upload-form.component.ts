
import { Component, ElementRef, OnInit, ViewChild } from "@angular/core";
import { OpenProjectFileUploadService, UploadFile } from "core-app/core/file-upload/op-file-upload.service";
import { resizeFile } from "core-app/shared/helpers/images/resizer";
import { I18nService } from "core-app/core/i18n/i18n.service";
import { ToastService } from "core-app/shared/components/toaster/toast.service";

@Component({
  selector: 'avatar-upload-form',
  templateUrl: './avatar-upload-form.html'
})
export class AvatarUploadFormComponent implements OnInit {
  // Form targets
  public form:any;
  public target:string;
  public method:string;

  // File
  public avatarFile:any;
  public avatarPreviewUrl:any;
  public busy = false;
  public fileInvalid = false;

  @ViewChild('avatarFilePicker', { static: true }) public avatarFilePicker:ElementRef;

  // Text
  public text = {
    label_choose_avatar: this.I18n.t('js.avatars.label_choose_avatar'),
    upload_instructions: this.I18n.t('js.avatars.text_upload_instructions'),
    error_too_large: this.I18n.t('js.avatars.error_image_too_large'),
    wrong_file_format: this.I18n.t('js.avatars.wrong_file_format'),
    button_update: this.I18n.t('js.button_update'),
    uploading: this.I18n.t('js.avatars.uploading_avatar'),
    preview: this.I18n.t('js.label_preview')
  };

  public constructor(protected I18n:I18nService,
                     protected elementRef:ElementRef,
                     protected toastService:ToastService,
                     protected opFileUpload:OpenProjectFileUploadService) {
  }

  public ngOnInit() {
    const element = this.elementRef.nativeElement;
    this.target = element.getAttribute('target');
    this.method = element.getAttribute('method');
  }

  public onFilePickerChanged(_evt:Event) {
    const files:UploadFile[] = Array.from(this.avatarFilePicker.nativeElement.files);
    if (files.length === 0) {
      return;
    }

    const file = files[0];
    if (['image/jpeg', 'image/png', 'image/gif'].indexOf(file.type) === -1) {
      this.fileInvalid = true;
      return;
    }

    resizeFile(128, file).then(([dataURL, blob]) => {
      // Create resized file
      blob.name = file.name;
      this.avatarFile = blob;
      this.avatarPreviewUrl = dataURL;
    });
  }

  public uploadAvatar(evt:Event) {
    evt.preventDefault();
    this.busy = true;
    const upload = this.opFileUpload.uploadSingle(this.target, this.avatarFile, this.method, 'text');
    this.toastService.addAttachmentUpload(this.text.uploading, [upload]);

    upload[1].subscribe(
      (evt:any) => {
        switch (evt.type) {
        case 0: // Sent
          return;

        case 4:
          this.avatarFile.progress = 100;
          this.busy = false;
          window.location.reload();
          return;

        default:
          // Sent or unknown event
          return;
        }
      },
      (error:any) => {
        this.toastService.addError(error.error);
        this.busy = false;
      }
    );
  }
}
