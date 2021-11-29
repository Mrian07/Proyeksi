

import { Component, Input } from '@angular/core';

@Component({
  selector: 'op-icon',
  host: { class: 'op-icon--wrapper' },
  template: `
      <i [ngClass]="iconClasses"
         [title]="iconTitle"
         aria-hidden="true"></i>
      <span
        class="hidden-for-sighted"
        [textContent]="iconTitle"
        *ngIf="iconTitle"></span>
    `,
})
export class OpIconComponent {
  @Input('icon-classes') iconClasses:string;

  @Input('icon-title') iconTitle = '';
}
