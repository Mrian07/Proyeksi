

import { WorkPackageCreateComponent } from 'core-app/features/work-packages/components/wp-new/wp-create.component';
import { Component } from '@angular/core';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { IFCViewerService } from 'core-app/features/bim/ifc_models/ifc-viewer/ifc-viewer.service';

@Component({
  selector: 'bcf-new-split',
  templateUrl: './bcf-new-split.component.html',
})
export class BCFNewSplitComponent extends WorkPackageCreateComponent {
  public cancelState = '^';

  @InjectField()
  readonly viewer:IFCViewerService;

  public onSaved(params:{ savedResource:WorkPackageResource, isInitial:boolean }) {
    super.onSaved(params);
  }
}
