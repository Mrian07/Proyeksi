

import {
  ChangeDetectorRef, Component, ElementRef, Input, OnInit,
} from '@angular/core';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { HalResourceService } from 'core-app/features/hal/services/hal-resource.service';
import { filter } from 'rxjs/operators';
import { States } from 'core-app/core/states/states.service';
import { trackByHref } from 'core-app/shared/helpers/angular/tracking-functions';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';

@Component({
  selector: 'attachment-list',
  templateUrl: './attachment-list.html',
})
export class AttachmentListComponent extends UntilDestroyedMixin implements OnInit {
  @Input() public resource:HalResource;

  @Input() public destroyImmediately = true;

  trackByHref = trackByHref;

  attachments:HalResource[] = [];

  deletedAttachments:HalResource[] = [];

  public $element:JQuery;

  public $formElement:JQuery;

  constructor(protected elementRef:ElementRef,
    protected states:States,
    protected cdRef:ChangeDetectorRef,
    protected halResourceService:HalResourceService) {
    super();
  }

  ngOnInit() {
    this.$element = jQuery(this.elementRef.nativeElement);

    this.updateAttachments();
    this.setupResourceUpdateListener();

    if (!this.destroyImmediately) {
      this.setupAttachmentDeletionCallback();
    }
  }

  public setupResourceUpdateListener() {
    this.states.forResource(this.resource)!
      .values$()
      .pipe(
        this.untilDestroyed(),
        filter((newResource) => !!newResource),
      )
      .subscribe((newResource:HalResource) => {
        this.resource = newResource || this.resource;

        this.updateAttachments();
        this.cdRef.detectChanges();
      });
  }

  ngOnDestroy():void {
    super.ngOnDestroy();
    if (!this.destroyImmediately) {
      this.$formElement.off('submit.attachment-component');
    }
  }

  public removeAttachment(attachment:HalResource) {
    this.deletedAttachments.push(attachment);
    // Keep the same object as we would otherwise loose the connection to the
    // resource's attachments array. That way, attachments added after removing one would not be displayed.
    // This is bad design.
    const newAttachments = this.attachments.filter((el) => el !== attachment);
    this.attachments.length = 0;
    this.attachments.push(...newAttachments);

    this.cdRef.detectChanges();
  }

  private get attachmentsUpdatable() {
    return (this.resource.attachments && this.resource.attachmentsBackend);
  }

  public setupAttachmentDeletionCallback() {
    this.$formElement = this.$element.closest('form');
    this.$formElement.on('submit.attachment-component', () => {
      this.destroyRemovedAttachments();
    });
  }

  private destroyRemovedAttachments() {
    this.deletedAttachments.forEach((attachment) => {
      this
        .resource
        .removeAttachment(attachment);
    });
  }

  private updateAttachments() {
    if (!this.attachmentsUpdatable) {
      this.attachments = this.resource.attachments.elements;
      return;
    }

    this
      .resource
      .attachments
      .updateElements()
      .then(() => {
        this.attachments = this.resource.attachments.elements;
        this.cdRef.detectChanges();
      });
  }
}
