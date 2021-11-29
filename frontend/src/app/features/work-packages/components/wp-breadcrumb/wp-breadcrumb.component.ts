

import { Component, Input } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';

@Component({
  templateUrl: './wp-breadcrumb.html',
  styleUrls: ['./wp-breadcrumb.sass'],
  selector: 'wp-breadcrumb',
})
export class WorkPackageBreadcrumbComponent {
  @Input('workPackage') workPackage:WorkPackageResource;

  public text = {
    parent: this.I18n.t('js.relations_hierarchy.parent_headline'),
    hierarchy: this.I18n.t('js.relations_hierarchy.hierarchy_headline'),
  };

  constructor(private I18n:I18nService) {
  }

  public inputActive = false;

  public get hierarchyCount() {
    return this.workPackage.ancestors.length;
  }

  public get hierarchyLabel() {
    return (this.hierarchyCount === 1) ? this.text.parent : this.text.hierarchy;
  }

  public updateActiveInput(val:boolean) {
    this.inputActive = val;
  }
}
