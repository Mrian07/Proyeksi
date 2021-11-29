

import { ChangeDetectionStrategy, Component } from '@angular/core';

@Component({
  template: `
    <button class="button"
            id="wp-fold-toggle-button"
            wpGroupToggleDropdown>
      <op-icon icon-classes="button--icon icon-outline"></op-icon>
      <span class="button--text"></span>
      <op-icon icon-classes="button--icon icon-small icon-pulldown"></op-icon>
    </button>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'wp-fold-toggle-view-button',
})
export class WorkPackageFoldToggleButtonComponent {
}
