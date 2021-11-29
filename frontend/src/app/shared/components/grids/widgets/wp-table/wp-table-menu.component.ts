

import { Component } from '@angular/core';
import { WpTableConfigurationModalComponent } from 'core-app/features/work-packages/components/wp-table/configuration-modal/wp-table-configuration.modal';
import { WidgetWpSetMenuComponent } from 'core-app/shared/components/grids/widgets/menu/wp-set-menu.component';

@Component({
  selector: 'widget-wp-table-menu',
  templateUrl: '../menu/widget-menu.component.html',
})
export class WidgetWpTableMenuComponent extends WidgetWpSetMenuComponent {
  protected configurationComponent = WpTableConfigurationModalComponent;
}
