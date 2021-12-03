import { NgModule } from '@angular/core';
import { ProyeksiappModalModule } from 'core-app/shared/components/modal/modal.module';
import { NgSelectModule } from '@ng-select/ng-select';
import { OPSharedModule } from 'core-app/shared/shared.module';
import { DraggableAutocompleteComponent } from 'core-app/shared/components/autocompleter/draggable-autocomplete/draggable-autocomplete.component';
import { DynamicModule } from 'ng-dynamic-component';
import { ColorsAutocompleterComponent } from 'core-app/shared/components/colors/colors-autocompleter.component';
import { WorkPackageAutocompleterComponent } from 'core-app/shared/components/autocompleter/work-package-autocompleter/wp-autocompleter.component';
import { TimeEntryWorkPackageAutocompleterComponent } from 'core-app/shared/components/autocompleter/te-work-package-autocompleter/te-work-package-autocompleter.component';
import { AutocompleteSelectDecorationComponent } from 'core-app/shared/components/autocompleter/autocomplete-select-decoration/autocomplete-select-decoration.component';
import { VersionAutocompleterComponent } from 'core-app/shared/components/autocompleter/version-autocompleter/version-autocompleter.component';
import { UserAutocompleterComponent } from 'core-app/shared/components/autocompleter/user-autocompleter/user-autocompleter.component';
import { CommonModule } from '@angular/common';
import { ProyeksiappInviteUserModalModule } from 'core-app/features/invite-user-modal/invite-user-modal.module';
import { DragulaModule } from 'ng2-dragula';
import { OpAutocompleterComponent } from 'core-app/shared/components/autocompleter/op-autocompleter/op-autocompleter.component';
import { OpAutocompleterOptionTemplateDirective } from 'core-app/shared/components/autocompleter/op-autocompleter/directives/op-autocompleter-option-template.directive';
import { OpAutocompleterLabelTemplateDirective } from 'core-app/shared/components/autocompleter/op-autocompleter/directives/op-autocompleter-label-template.directive';
import { OpAutocompleterHeaderTemplateDirective } from 'core-app/shared/components/autocompleter/op-autocompleter/directives/op-autocompleter-header-template.directive';
import { CreateAutocompleterComponent } from 'core-app/shared/components/autocompleter/create-autocompleter/create-autocompleter.component';
import { OpAutocompleterFooterTemplateDirective } from 'core-app/shared/components/autocompleter/autocompleter-footer-template/op-autocompleter-footer-template.directive';

export const PROYEKSIAPP_AUTOCOMPLETE_COMPONENTS = [
  CreateAutocompleterComponent,
  VersionAutocompleterComponent,
  WorkPackageAutocompleterComponent,
  TimeEntryWorkPackageAutocompleterComponent,
  DraggableAutocompleteComponent,
  UserAutocompleterComponent,
  ColorsAutocompleterComponent,
  AutocompleteSelectDecorationComponent,
  OpAutocompleterComponent,
  OpAutocompleterOptionTemplateDirective,
  OpAutocompleterLabelTemplateDirective,
  OpAutocompleterHeaderTemplateDirective,
  OpAutocompleterFooterTemplateDirective,
];

@NgModule({
  imports: [
    CommonModule,
    OPSharedModule,
    ProyeksiappModalModule,
    ProyeksiappInviteUserModalModule,
    NgSelectModule,
    DragulaModule,

    DynamicModule.withComponents(PROYEKSIAPP_AUTOCOMPLETE_COMPONENTS),
  ],
  exports: PROYEKSIAPP_AUTOCOMPLETE_COMPONENTS,
  declarations: PROYEKSIAPP_AUTOCOMPLETE_COMPONENTS,
})
export class ProyeksiappAutocompleterModule { }
