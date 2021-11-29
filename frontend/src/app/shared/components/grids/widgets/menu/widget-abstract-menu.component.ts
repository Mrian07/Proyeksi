

import { Directive, Input } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { OpContextMenuItem } from 'core-app/shared/components/op-context-menu/op-context-menu.types';
import { GridWidgetResource } from 'core-app/features/hal/resources/grid-widget-resource';
import { GridRemoveWidgetService } from 'core-app/shared/components/grids/grid/remove-widget.service';
import { GridAreaService } from 'core-app/shared/components/grids/grid/area.service';

@Directive()
export abstract class WidgetAbstractMenuComponent {
  @Input() resource:GridWidgetResource;

  protected menuItemList:OpContextMenuItem[] = [this.removeItem];

  constructor(readonly i18n:I18nService,
    protected readonly remove:GridRemoveWidgetService,
    protected readonly layout:GridAreaService) {
  }

  public get menuItems() {
    return async () => this.menuItemList;
  }

  protected get removeItem() {
    return {
      linkText: this.i18n.t('js.grid.remove'),
      onClick: () => {
        this.remove.widget(this.resource);
        return true;
      },
    };
  }

  public get hasMenu() {
    return this.layout.isEditable;
  }
}
