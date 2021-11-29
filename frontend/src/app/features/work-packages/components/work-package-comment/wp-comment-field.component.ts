

import { ConfigurationService } from 'core-app/core/config/configuration.service';
import { Component, OnInit } from '@angular/core';
import {
  FormattableEditFieldComponent,
} from 'core-app/shared/components/fields/edit/field-types/formattable-edit-field/formattable-edit-field.component';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';

@Component({
  templateUrl: '../../../../shared/components/fields/edit/field-types/formattable-edit-field/formattable-edit-field.component.html',
})
export class WorkPackageCommentFieldComponent extends FormattableEditFieldComponent implements OnInit {
  public isBusy = false;

  public name = 'comment';

  @InjectField() public ConfigurationService:ConfigurationService;

  public get required() {
    return true;
  }

  ngOnInit() {
    super.ngOnInit();
  }
}
