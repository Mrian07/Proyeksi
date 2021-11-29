

import { AfterViewInit, Component } from '@angular/core';
import { CreateAutocompleterComponent } from 'core-app/shared/components/autocompleter/create-autocompleter/create-autocompleter.component';

@Component({
  templateUrl: '../create-autocompleter/create-autocompleter.component.html',
  selector: 'wp-autocompleter',
})
export class WorkPackageAutocompleterComponent extends CreateAutocompleterComponent implements AfterViewInit {
}
