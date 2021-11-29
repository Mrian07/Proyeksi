

import { ChangeDetectionStrategy, Component } from '@angular/core';
import { AbstractWidgetComponent } from 'core-app/shared/components/grids/widgets/abstract-widget.component';

@Component({
  templateUrl: './wp-overview.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class WidgetWpOverviewComponent extends AbstractWidgetComponent {
}
