

import { ChangeDetectionStrategy, Component } from '@angular/core';
import { WorkPackageCopyController } from 'core-app/features/work-packages/components/wp-copy/wp-copy.controller';

@Component({
  selector: 'wp-copy-split-view',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: '../wp-new/wp-new-split-view.html',
})
export class WorkPackageCopySplitViewComponent extends WorkPackageCopyController {
}
