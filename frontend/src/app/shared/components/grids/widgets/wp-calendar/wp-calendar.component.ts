

import { Component, Injector } from '@angular/core';
import { AbstractWidgetComponent } from 'core-app/shared/components/grids/widgets/abstract-widget.component';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';

@Component({
  templateUrl: './wp-calendar.component.html',
})
export class WidgetWpCalendarComponent extends AbstractWidgetComponent {
  constructor(protected readonly i18n:I18nService,
    protected readonly injector:Injector,
    protected readonly currentProject:CurrentProjectService) {
    super(i18n, injector);
  }

  public get projectIdentifier() {
    return this.currentProject.identifier;
  }
}
