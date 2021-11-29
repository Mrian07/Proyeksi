

import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import {
  Component, ElementRef, EventEmitter, Input, Output, ViewChild,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';

@Component({
  selector: 'wp-relations-group',
  templateUrl: './wp-relations-group.template.html',
})
export class WorkPackageRelationsGroupComponent {
  @Input() public relatedWorkPackages:WorkPackageResource[];

  @Input() public workPackage:WorkPackageResource;

  @Input() public header:string;

  @Input() public firstGroup:boolean;

  @Input() public groupByWorkPackageType:boolean;

  @Output() public onToggleGroupBy = new EventEmitter<undefined>();

  @ViewChild('wpRelationGroupByToggler') readonly toggleElement:ElementRef;

  public text = {
    groupByType: this.I18n.t('js.relation_buttons.group_by_wp_type'),
    groupByRelation: this.I18n.t('js.relation_buttons.group_by_relation_type'),
  };

  constructor(
    readonly I18n:I18nService,
  ) {
  }

  public get togglerText() {
    if (this.groupByWorkPackageType) {
      return this.text.groupByRelation;
    }
    return this.text.groupByType;
  }

  public toggleButton() {
    this.onToggleGroupBy.emit();

    setTimeout(() => {
      this.toggleElement.nativeElement.focus();
    }, 20);
  }
}
