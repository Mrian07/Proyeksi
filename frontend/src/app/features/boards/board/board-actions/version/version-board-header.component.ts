
import { Component, Input } from '@angular/core';
import { VersionResource } from 'core-app/features/hal/resources/version-resource';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';

@Component({
  templateUrl: './version-board-header.html',
  styleUrls: ['./version-board-header.sass'],
  host: { class: 'title-container -small' },
})
export class VersionBoardHeaderComponent {
  @Input('resource') public version:VersionResource;

  constructor(readonly I18n:I18nService,
    readonly pathHelper:PathHelperService) {
  }

  public text = {
    isLocked: this.I18n.t('js.boards.version.is_locked'),
    isClosed: this.I18n.t('js.boards.version.is_closed'),
    version: this.I18n.t('js.work_packages.properties.version'),
  };
}
