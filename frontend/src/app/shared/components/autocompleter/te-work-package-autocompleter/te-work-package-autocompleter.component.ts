

import {
  AfterViewInit, Component, EventEmitter, Injector, Output, ViewEncapsulation,
} from '@angular/core';
import { of } from 'rxjs';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { WorkPackageAutocompleterComponent } from 'core-app/shared/components/autocompleter/work-package-autocompleter/wp-autocompleter.component';

export type TimeEntryWorkPackageAutocompleterMode = 'all'|'recent';

@Component({
  templateUrl: './te-work-package-autocompleter.component.html',
  styleUrls: [
    './te-work-package-autocompleter.component.sass',
  ],
  selector: 'te-work-package-autocompleter',
  encapsulation: ViewEncapsulation.None,
})
export class TimeEntryWorkPackageAutocompleterComponent extends WorkPackageAutocompleterComponent implements AfterViewInit {
  @Output() modeSwitch = new EventEmitter<TimeEntryWorkPackageAutocompleterMode>();

  constructor(
    readonly injector:Injector,
  ) {
    super(injector);

    this.text.all = this.I18n.t('js.label_all');
    this.text.recent = this.I18n.t('js.label_recent');
  }

  public loading = false;

  public mode:TimeEntryWorkPackageAutocompleterMode = 'all';

  public setMode(value:TimeEntryWorkPackageAutocompleterMode) {
    if (value !== this.mode) {
      this.modeSwitch.emit(value);
    }
    this.mode = value;
  }
}
