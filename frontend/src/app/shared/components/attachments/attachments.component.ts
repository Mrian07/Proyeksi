

import {
  Component, ElementRef, Input, OnInit,
} from '@angular/core';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { HalResourceService } from 'core-app/features/hal/services/hal-resource.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { States } from 'core-app/core/states/states.service';
import { filter } from 'rxjs/operators';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';

export const attachmentsSelector = 'attachments';

@Component({
  selector: attachmentsSelector,
  templateUrl: './attachments.html',
})
export class AttachmentsComponent extends UntilDestroyedMixin implements OnInit {
  @Input('resource') public resource:HalResource;

  public $element:JQuery;

  public allowUploading:boolean;

  public destroyImmediately:boolean;

  public text:any;

  constructor(protected elementRef:ElementRef,
    protected I18n:I18nService,
    protected states:States,
    protected halResourceService:HalResourceService) {
    super();

    this.text = {
      attachments: this.I18n.t('js.label_attachments'),
    };
  }

  ngOnInit() {
    this.$element = jQuery(this.elementRef.nativeElement);

    if (!this.resource) {
      // Parse the resource if any exists
      const source = this.$element.data('resource');
      this.resource = this.halResourceService.createHalResource(source, true);
    }

    this.allowUploading = this.$element.data('allow-uploading');

    if (this.$element.data('destroy-immediately') !== undefined) {
      this.destroyImmediately = this.$element.data('destroy-immediately');
    } else {
      this.destroyImmediately = true;
    }

    this.setupResourceUpdateListener();
  }

  public setupResourceUpdateListener() {
    this.states.forResource(this.resource)!.changes$()
      .pipe(
        this.untilDestroyed(),
        filter((newResource) => !!newResource),
      )
      .subscribe((newResource:HalResource) => {
        this.resource = newResource || this.resource;
      });
  }

  // Only show attachment list when allow uploading is set
  // or when at least one attachment exists
  public showAttachments() {
    return this.allowUploading || _.get(this.resource, 'attachments.count', 0) > 0;
  }
}
