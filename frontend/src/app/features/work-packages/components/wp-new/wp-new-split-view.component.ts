

import { WorkPackageCreateComponent } from 'core-app/features/work-packages/components/wp-new/wp-create.component';
import { ChangeDetectionStrategy, Component } from '@angular/core';

@Component({
  selector: 'wp-new-split-view',
  templateUrl: './wp-new-split-view.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class WorkPackageNewSplitViewComponent extends WorkPackageCreateComponent {
}
