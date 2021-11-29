

import { ChangeDetectionStrategy, Component } from '@angular/core';
import { WorkPackageCopyController } from 'core-app/features/work-packages/components/wp-copy/wp-copy.controller';

@Component({
  selector: 'wp-copy-full-view',
  host: { class: 'work-packages-page--ui-view' },
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: '../wp-new/wp-new-full-view.html',
})
export class WorkPackageCopyFullViewComponent extends WorkPackageCopyController {
  public successState = 'work-packages.show';
}
