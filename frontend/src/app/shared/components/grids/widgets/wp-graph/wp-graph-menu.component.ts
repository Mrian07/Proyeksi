

import { Component } from '@angular/core';
import { WpGraphConfigurationModalComponent } from 'core-app/shared/components/work-package-graphs/configuration-modal/wp-graph-configuration.modal';
import { WidgetWpSetMenuComponent } from 'core-app/shared/components/grids/widgets/menu/wp-set-menu.component';

@Component({
  selector: 'widget-wp-graph-menu',
  templateUrl: '../menu/widget-menu.component.html',
})
export class WidgetWpGraphMenuComponent extends WidgetWpSetMenuComponent {
  protected configurationComponent = WpGraphConfigurationModalComponent;
}
