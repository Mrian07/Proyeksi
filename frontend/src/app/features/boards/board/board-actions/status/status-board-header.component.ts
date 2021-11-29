
import { Component, Input } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { StatusResource } from 'core-app/features/hal/resources/status-resource';

@Component({
  templateUrl: './status-board-header.html',
  styleUrls: ['./status-board-header.sass'],
  host: { class: 'title-container -small' },
})
export class StatusBoardHeaderComponent {
  @Input('resource') public status:StatusResource;

  text = {
    status: this.I18n.t('js.work_packages.properties.status'),
  };

  constructor(readonly I18n:I18nService) {
  }
}
