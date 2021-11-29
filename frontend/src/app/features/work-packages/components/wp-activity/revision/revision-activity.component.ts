
import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, OnInit,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { TimezoneService } from 'core-app/core/datetime/timezone.service';
import { UserResource } from 'core-app/features/hal/resources/user-resource';
import { ProjectResource } from 'core-app/features/hal/resources/project-resource';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import idFromLink from 'core-app/features/hal/helpers/id-from-link';

@Component({
  selector: 'revision-activity',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './revision-activity.component.html',
})
export class RevisionActivityComponent implements OnInit {
  @Input() public workPackage:WorkPackageResource;

  @Input() public activity:any;

  @Input() public activityNo:number;

  @Input() public hasUnreadNotification:boolean;

  public userId:string | number;

  public userName:string;

  public userActive:boolean;

  public userPath:string | null;

  public userLabel:string;

  public userAvatar:string;

  public project:ProjectResource;

  public revision:string;

  public message:string;

  public revisionLink:string;

  constructor(readonly I18n:I18nService,
    readonly timezoneService:TimezoneService,
    readonly cdRef:ChangeDetectorRef,
    readonly apiV3Service:APIV3Service) {
  }

  ngOnInit() {
    this.loadAuthor();

    this.project = this.workPackage.project;
    this.revision = this.activity.identifier;
    this.message = this.activity.message.html;

    const revisionPath = this.activity.showRevision.$link.href;
    const formattedRevision = this.activity.formattedIdentifier;

    const link = document.createElement('a');
    link.href = revisionPath;
    link.title = this.revision;
    link.textContent = this.I18n.t(
      'js.label_committed_link',
      { revision_identifier: formattedRevision },
    );

    this.revisionLink = this.I18n.t('js.label_committed_at',
      {
        committed_revision_link: link.outerHTML,
        date: this.timezoneService.formattedDatetime(this.activity.createdAt),
      });
  }

  private loadAuthor() {
    if (this.activity.author === undefined) {
      this.userName = this.activity.authorName;
    } else {
      this
        .apiV3Service
        .users
        .id(idFromLink(this.activity.author.href))
        .get()
        .subscribe((user:UserResource) => {
          this.userId = user.id!;
          this.userName = user.name;
          this.userActive = user.isActive;
          this.userAvatar = user.avatar;
          this.userPath = user.showUser.href;
          this.userLabel = this.I18n.t('js.label_author', { user: this.userName });
          this.cdRef.detectChanges();
        });
    }
  }
}
