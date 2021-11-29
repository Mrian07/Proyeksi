

import { Component, Input, OnInit } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';
import idFromLink from 'core-app/features/hal/helpers/id-from-link';

@Component({
  templateUrl: './authoring.component.html',
  styleUrls: ['./authoring.component.sass'],
  selector: 'authoring',
})
export class AuthoringComponent implements OnInit {
  // scope: { createdOn: '=', author: '=', showAuthorAsLink: '=', project: '=', activity: '=' },
  @Input('createdOn') createdOn:string;

  @Input('author') author:HalResource;

  @Input('showAuthorAsLink') showAuthorAsLink:boolean;

  @Input('project') project:any;

  @Input('activity') activity:any;

  public createdOnTime:any;

  public timeago:any;

  public time:any;

  public userLink:string;

  public constructor(readonly PathHelper:PathHelperService,
    readonly I18n:I18nService,
    readonly timezoneService:TimezoneService) {

  }

  ngOnInit() {
    this.createdOnTime = this.timezoneService.parseDatetime(this.createdOn);
    this.timeago = this.createdOnTime.fromNow();
    this.time = this.createdOnTime.format('LLL');
    this.userLink = this.PathHelper.userPath(idFromLink(this.author.href));
  }

  public activityFromPath(from:any) {
    let path = this.PathHelper.projectActivityPath(this.project);

    if (from) {
      path += `?from=${from}`;
    }

    return path;
  }
}
