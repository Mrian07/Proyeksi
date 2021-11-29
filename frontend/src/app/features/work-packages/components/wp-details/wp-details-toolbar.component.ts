

import { HalResourceEditingService } from 'core-app/shared/components/fields/edit/services/hal-resource-editing.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { Component, Input } from '@angular/core';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';

@Component({
  selector: 'wp-details-toolbar',
  templateUrl: './wp-details-toolbar.html',
})
export class WorkPackageSplitViewToolbarComponent {
  @Input('workPackage') workPackage:WorkPackageResource;

  public text = {
    button_more: this.I18n.t('js.button_more'),
  };

  constructor(readonly I18n:I18nService,
    readonly halEditing:HalResourceEditingService) {}
}
