

import { Component, HostBinding, Input } from '@angular/core';

@Component({
  templateUrl: './no-results.component.html',
  selector: 'no-results',
})

export class NoResultsComponent {
  @Input() title:string;

  @Input() description:string;

  @Input() showIcon = true;

  @HostBinding('class.generic-table--no-results-container') setHostClass = true;
}
