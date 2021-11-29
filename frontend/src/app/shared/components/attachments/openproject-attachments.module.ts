

import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { IconModule } from 'core-app/shared/components/icon/icon.module';

import { AttachmentsComponent } from './attachments.component';
import { AttachmentListComponent } from './attachment-list/attachment-list.component';
import { AttachmentListItemComponent } from './attachment-list/attachment-list-item.component';
import { AttachmentsUploadComponent } from './attachments-upload/attachments-upload.component';
import { AuthoringComponent } from './authoring/authoring.component';

@NgModule({
  imports: [
    CommonModule,
    IconModule,
  ],
  declarations: [
    AttachmentsComponent,
    AttachmentListComponent,
    AttachmentListItemComponent,
    AttachmentsUploadComponent,

    AuthoringComponent,
  ],
  exports: [
    AttachmentsUploadComponent,
    AttachmentListComponent,
    AttachmentsComponent,

    AuthoringComponent,
  ],
})
export class OpenprojectAttachmentsModule {
}
