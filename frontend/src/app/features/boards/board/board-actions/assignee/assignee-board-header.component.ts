
import { Component, Input } from '@angular/core';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { UserResource } from 'core-app/features/hal/resources/user-resource';

@Component({
  templateUrl: './assignee-board-header.html',
  styleUrls: ['./assignee-board-header.sass'],
  host: { class: 'title-container -small' },
})
export class AssigneeBoardHeaderComponent {
  @Input('resource') public user:UserResource;

  text = {
    assignee: this.I18n.t('js.work_packages.properties.assignee'),
  };

  constructor(readonly pathHelper:PathHelperService,
    readonly I18n:I18nService) {
  }
}
