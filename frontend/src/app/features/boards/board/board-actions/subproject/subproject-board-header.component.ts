
import { Component, Input } from '@angular/core';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import idFromLink from 'core-app/features/hal/helpers/id-from-link';

@Component({
  templateUrl: './subproject-board-header.html',
  styleUrls: ['./subproject-board-header.sass'],
  host: { class: 'title-container -small' },
})
export class SubprojectBoardHeaderComponent {
  @Input() public resource:HalResource;

  idFromLink = idFromLink;

  text = {
    project: this.I18n.t('js.time_entry.project'),
  };

  constructor(readonly pathHelper:PathHelperService,
    readonly I18n:I18nService) {
  }
}
