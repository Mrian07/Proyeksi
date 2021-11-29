

import { APP_INITIALIZER, NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { OpenprojectModalModule } from 'core-app/shared/components/modal/modal.module';
import { OpenprojectEditorModule } from 'core-app/shared/components/editor/openproject-editor.module';
import { OpenprojectAttachmentsModule } from 'core-app/shared/components/attachments/openproject-attachments.module';
import { OPSharedModule } from 'core-app/shared/shared.module';
import { AttributeHelpTextModule } from 'core-app/shared/components/attribute-help-texts/attribute-help-text.module';
import { EditFieldService } from 'core-app/shared/components/fields/edit/edit-field.service';
import { DisplayFieldService } from 'core-app/shared/components/fields/display/display-field.service';
import { initializeCoreEditFields } from 'core-app/shared/components/fields/edit/edit-field.initializer';
import { initializeCoreDisplayFields } from 'core-app/shared/components/fields/display/display-field.initializer';
import { DurationEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/duration-edit-field.component';
import { FloatEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/float-edit-field.component';
import { MultiSelectEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/multi-select-edit-field.component';
import { EditFormPortalComponent } from 'core-app/shared/components/fields/edit/editing-portal/edit-form-portal.component';
import { SelectAutocompleterRegisterService } from 'core-app/shared/components/fields/edit/field-types/select-edit-field/select-autocompleter-register.service';
import { EditFormComponent } from 'core-app/shared/components/fields/edit/edit-form/edit-form.component';
import { WorkPackageEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/work-package-edit-field.component';
import { EditableAttributeFieldComponent } from 'core-app/shared/components/fields/edit/field/editable-attribute-field.component';
import { ProjectStatusEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/project-status-edit-field.component';
import { PlainFormattableEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/plain-formattable-edit-field.component';
import { TimeEntryWorkPackageEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/te-work-package-edit-field.component';
import { AttributeValueMacroComponent } from 'core-app/shared/components/fields/macros/attribute-value-macro.component';
import { AttributeLabelMacroComponent } from 'core-app/shared/components/fields/macros/attribute-label-macro.component';
import { WorkPackageQuickinfoMacroComponent } from 'core-app/shared/components/fields/macros/work-package-quickinfo-macro.component';
import { DisplayFieldComponent } from 'core-app/shared/components/fields/display/display-field.component';
import { OpenprojectAutocompleterModule } from 'core-app/shared/components/autocompleter/openproject-autocompleter.module';
import { BooleanEditFieldModule } from 'core-app/shared/components/fields/edit/field-types/boolean-edit-field/boolean-edit-field.module';
import { IntegerEditFieldModule } from 'core-app/shared/components/fields/edit/field-types/integer-edit-field/integer-edit-field.module';
import { TextEditFieldModule } from 'core-app/shared/components/fields/edit/field-types/text-edit-field/text-edit-field.module';
import { DateEditFieldModule } from 'core-app/shared/components/fields/edit/field-types/date-edit-field/date-edit-field.module';
import { SelectEditFieldModule } from 'core-app/shared/components/fields/edit/field-types/select-edit-field/select-edit-field.module';
import { FormattableEditFieldModule } from 'core-app/shared/components/fields/edit/field-types/formattable-edit-field/formattable-edit-field.module';
import { EditFieldControlsModule } from 'core-app/shared/components/fields/edit/field-controls/edit-field-controls.module';

@NgModule({
  imports: [
    CommonModule,
    OPSharedModule,
    OpenprojectAttachmentsModule,
    OpenprojectEditorModule,
    OpenprojectModalModule,
    OpenprojectAutocompleterModule,
    AttributeHelpTextModule,
    // Input Modules
    BooleanEditFieldModule,
    IntegerEditFieldModule,
    TextEditFieldModule,
    DateEditFieldModule,
    SelectEditFieldModule,
    FormattableEditFieldModule,
    EditFieldControlsModule,
  ],
  exports: [
    EditFormPortalComponent,
    EditFormComponent,
    EditableAttributeFieldComponent,
  ],
  providers: [
    {
      provide: APP_INITIALIZER,
      useFactory: initializeCoreEditFields,
      deps: [EditFieldService, SelectAutocompleterRegisterService],
      multi: true,
    },
    {
      provide: APP_INITIALIZER,
      useFactory: initializeCoreDisplayFields,
      deps: [DisplayFieldService],
      multi: true,
    },
  ],
  declarations: [
    EditFormPortalComponent,
    DurationEditFieldComponent,
    FloatEditFieldComponent,
    PlainFormattableEditFieldComponent,
    MultiSelectEditFieldComponent,
    WorkPackageEditFieldComponent,
    TimeEntryWorkPackageEditFieldComponent,
    EditFormComponent,
    DisplayFieldComponent,
    EditableAttributeFieldComponent,
    ProjectStatusEditFieldComponent,
    AttributeValueMacroComponent,
    AttributeLabelMacroComponent,

    WorkPackageQuickinfoMacroComponent,
  ],
})
export class OpenprojectFieldsModule {
}
