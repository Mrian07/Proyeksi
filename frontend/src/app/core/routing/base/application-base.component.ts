

import { Component } from '@angular/core';

export const appBaseSelector = 'openproject-base';

@Component({
  selector: appBaseSelector,
  template: `
    <div class="openproject-base--ui-view">
      <ui-view></ui-view>
    </div>
  `,
})
export class ApplicationBaseComponent {
}
