

import {
  Component, EventEmitter, Input, Output,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { States } from 'core-app/core/states/states.service';
import { HalResourceNotificationService } from 'core-app/features/hal/services/hal-resource-notification.service';

@Component({
  selector: 'attachment-list-item',
  templateUrl: './attachment-list-item.html',
})
export class AttachmentListItemComponent {
  @Input() public resource:HalResource;

  @Input() public attachment:any;

  @Input() public index:any;

  @Input() destroyImmediately = true;

  @Output() public removeAttachment = new EventEmitter<void>();

  static imageFileExtensions:string[] = ['jpeg', 'jpg', 'gif', 'bmp', 'png'];

  public text = {
    dragHint: this.I18n.t('js.attachments.draggable_hint'),
    destroyConfirmation: this.I18n.t('js.text_attachment_destroy_confirmation'),
    removeFile: (arg:any) => this.I18n.t('js.label_remove_file', arg),
  };

  constructor(protected halNotification:HalResourceNotificationService,
    readonly I18n:I18nService,
    readonly states:States,
    readonly pathHelper:PathHelperService) {
  }

  /**
   * Set the appropriate data for drag & drop of an attachment item.
   * @param evt DragEvent
   */
  public setDragData(evt:DragEvent) {
    const url = this.downloadPath;
    const previewElement = this.draggableHTML(url);

    evt.dataTransfer!.setData('text/plain', url);
    evt.dataTransfer!.setData('text/html', previewElement.outerHTML);
    evt.dataTransfer!.setData('text/uri-list', url);
    evt.dataTransfer!.setDragImage(previewElement, 0, 0);
  }

  public draggableHTML(url:string) {
    let el:HTMLImageElement|HTMLAnchorElement;

    if (this.isImage) {
      el = document.createElement('img');
      el.src = url;
      el.textContent = this.fileName;
    } else {
      el = document.createElement('a');
      el.href = url;
      el.textContent = this.fileName;
    }

    return el;
  }

  public get downloadPath() {
    return this.pathHelper.attachmentDownloadPath(this.attachment.id, this.fileName);
  }

  public get isImage() {
    const ext = this.fileName.split('.').pop() || '';
    return AttachmentListItemComponent.imageFileExtensions.indexOf(ext.toLowerCase()) > -1;
  }

  public get fileName() {
    const a = this.attachment;
    return a.fileName || a.customName || a.name;
  }

  public confirmRemoveAttachment($event:JQuery.TriggeredEvent) {
    if (!window.confirm(this.text.destroyConfirmation)) {
      $event.stopImmediatePropagation();
      $event.preventDefault();
      return false;
    }

    this.removeAttachment.emit();

    if (this.destroyImmediately) {
      this
        .resource
        .removeAttachment(this.attachment);
    }

    return false;
  }
}
