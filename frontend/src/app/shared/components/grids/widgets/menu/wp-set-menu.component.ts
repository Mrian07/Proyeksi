

import {
  Directive, EventEmitter, Injector, Output,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { OpModalService } from 'core-app/shared/components/modal/modal.service';
import { OpModalComponent } from 'core-app/shared/components/modal/modal.component';
import { GridRemoveWidgetService } from 'core-app/shared/components/grids/grid/remove-widget.service';
import { ComponentType } from '@angular/cdk/portal';
import { WidgetAbstractMenuComponent } from 'core-app/shared/components/grids/widgets/menu/widget-abstract-menu.component';
import { WpGraphConfigurationModalComponent } from 'core-app/shared/components/work-package-graphs/configuration-modal/wp-graph-configuration.modal';
import { GridAreaService } from 'core-app/shared/components/grids/grid/area.service';

@Directive()
export abstract class WidgetWpSetMenuComponent extends WidgetAbstractMenuComponent {
  protected configurationComponent:ComponentType<OpModalComponent>;

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
      linkText: this.i18n.t('js.toolbar.settings.configure_view'),
      onClick: () => {
        this.opModalService.show(this.configurationComponent, this.injector, this.locals)
          .closingEvent.subscribe((modal:WpGraphConfigurationModalComponent) => {
            this.onConfigured.emit(modal.configuration);
          });
        return true;
      },
    };
  }

  protected get locals() {
    return {};
  }
}
