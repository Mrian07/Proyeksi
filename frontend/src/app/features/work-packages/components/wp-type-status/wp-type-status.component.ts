

import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { Component, Input } from '@angular/core';

@Component({
  selector: 'wp-type-status',
  templateUrl: './wp-type-status.html',
})
export class WorkPackageTypeStatusComponent {
  @Input('workPackage') workPackage:WorkPackageResource;
}
