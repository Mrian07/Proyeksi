

import {
  Component, EventEmitter, Injector, Output,
} from '@angular/core';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { GridRemoveWidgetService } from 'core-app/shared/components/grids/grid/remove-widget.service';
import { GridAreaService } from 'core-app/shared/components/grids/grid/area.service';
import { WidgetAbstractMenuComponent } from 'core-app/shared/components/grids/widgets/menu/widget-abstract-menu.component';
import { TimeEntriesCurrentUserConfigurationModalComponent } from 'core-app/shared/components/grids/widgets/time-entries/current-user/configuration-modal/configuration.modal';

@Component({
  selector: 'widget-time-entries-current-user-menu',
  templateUrl: '../../menu/widget-menu.component.html',
})
export class WidgetTimeEntriesCurrentUserMenuComponent extends WidgetAbstractMenuComponent {
  @Output()
  onConfigured:EventEmitter<any> = new EventEmitter();

  protected menuItemList = [
    this.removeItem,
    this.configureItem,
  ];

  constructor(private readonly injector:Injector,
    private readonly opModalService:OpModalService,
    readonly i18n:I18nService,
    protected readonly remove:GridRemoveWidgetService,
    readonly layout:GridAreaService) {
    super(i18n,
      remove,
      layout);
  }

  protected get configureItem() {
    return {
      linkText: this.i18n.t('js.grid.configure'),
      onClick: () => {
        this.opModalService.show(TimeEntriesCurrentUserConfigurationModalComponent, this.injector, this.locals)
          .closingEvent.subscribe((modal:TimeEntriesCurrentUserConfigurationModalComponent) => {
            if (modal.options) {
              this.onConfigured.emit(modal.options);
            }
          });
        return true;
      },
    };
  }

  protected get locals() {
    return { options: this.resource.options };
  }
}
