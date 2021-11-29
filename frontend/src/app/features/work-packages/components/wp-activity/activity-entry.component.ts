

import { Component, Input, OnInit } from '@angular/core';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import idFromLink from 'core-app/features/hal/helpers/id-from-link';

@Component({
  selector: 'activity-entry',
  templateUrl: './activity-entry.component.html',
})
export class ActivityEntryComponent implements OnInit {
  @Input() public workPackage:WorkPackageResource;

  @Input() public activity:any;

  @Input() public activityNo:number;

  @Input() public isInitial:boolean;

  @Input() public hasUnreadNotification:boolean;

  public projectId:string;

  public activityType:string;

  constructor(readonly PathHelper:PathHelperService,
    readonly I18n:I18nService) {
  }

  ngOnInit() {
    this.projectId = idFromLink(this.workPackage.project.href);

    this.activityType = this.activity._type;
  }
}
