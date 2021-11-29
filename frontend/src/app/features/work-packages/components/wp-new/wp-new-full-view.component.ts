

import { WorkPackageCreateComponent } from 'core-app/features/work-packages/components/wp-new/wp-create.component';
import { ChangeDetectionStrategy, Component } from '@angular/core';

@Component({
  selector: 'wp-new-full-view',
  host: { class: 'work-packages-page--ui-view' },
  templateUrl: './wp-new-full-view.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class WorkPackageNewFullViewComponent extends WorkPackageCreateComponent {
  public successState = this.$state.current.data.successState as string;
}
