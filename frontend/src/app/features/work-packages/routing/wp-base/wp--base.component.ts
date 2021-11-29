

import { Component } from '@angular/core';
import { EditFormRoutingService } from 'core-app/shared/components/fields/edit/edit-form/edit-form-routing.service';
import { WorkPackageEditFormRoutingService } from 'core-app/features/work-packages/routing/wp-edit-form/wp-edit-form-routing.service';

export const wpBaseSelector = 'work-packages-base';

@Component({
  selector: wpBaseSelector,
  template: `
    <div class="work-packages-page--ui-view" wp-isolated-query-space>
      <ui-view></ui-view>
    </div>
  `,
  providers: [
    { provide: EditFormRoutingService, useClass: WorkPackageEditFormRoutingService },
  ],
})
export class WorkPackagesBaseComponent {
}
