

import { EditFieldService } from 'core-app/shared/components/fields/edit/edit-field.service';
import { TextEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/text-edit-field/text-edit-field.component';
import { IntegerEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/integer-edit-field/integer-edit-field.component';
import { DurationEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/duration-edit-field.component';
import { SelectEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/select-edit-field/select-edit-field.component';
import { MultiSelectEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/multi-select-edit-field.component';
import { FloatEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/float-edit-field.component';
import { BooleanEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/boolean-edit-field/boolean-edit-field.component';
import { WorkPackageEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/work-package-edit-field.component';
import { DateEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/date-edit-field/date-edit-field.component';
import { FormattableEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/formattable-edit-field/formattable-edit-field.component';
import { SelectAutocompleterRegisterService } from 'core-app/shared/components/fields/edit/field-types/select-edit-field/select-autocompleter-register.service';
import { ProjectStatusEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/project-status-edit-field.component';
import { PlainFormattableEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/plain-formattable-edit-field.component';
import { TimeEntryWorkPackageEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/te-work-package-edit-field.component';
import { CombinedDateEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/combined-date-edit-field.component';
import { VersionAutocompleterComponent } from 'core-app/shared/components/autocompleter/version-autocompleter/version-autocompleter.component';
import { WorkPackageAutocompleterComponent } from 'core-app/shared/components/autocompleter/work-package-autocompleter/wp-autocompleter.component';
import { WorkPackageCommentFieldComponent } from 'core-app/features/work-packages/components/work-package-comment/wp-comment-field.component';

export function initializeCoreEditFields(editFieldService:EditFieldService, selectAutocompleterRegisterService:SelectAutocompleterRegisterService) {
  return () => {
    editFieldService.defaultFieldType = 'text';
    editFieldService
      .addFieldType(TextEditFieldComponent, 'text', ['String'])
      .addFieldType(IntegerEditFieldComponent, 'integer', ['Integer'])
      .addFieldType(DurationEditFieldComponent, 'duration', ['Duration'])
      .addFieldType(SelectEditFieldComponent, 'select', ['Priority',
        'Status',
        'Type',
        'User',
        'Version',
        'TimeEntriesActivity',
        'Category',
        'CustomOption',
        'Project'])
      .addFieldType(MultiSelectEditFieldComponent, 'multi-select', [
        '[]CustomOption',
        '[]User',
      ])
      .addFieldType(FloatEditFieldComponent, 'float', ['Float'])
      .addFieldType(WorkPackageEditFieldComponent, 'workPackage', ['WorkPackage'])
      .addFieldType(BooleanEditFieldComponent, 'boolean', ['Boolean'])
      .addFieldType(DateEditFieldComponent, 'date', ['Date'])
      .addFieldType(FormattableEditFieldComponent, 'wiki-textarea', ['Formattable'])
      .addFieldType(WorkPackageCommentFieldComponent, '_comment', ['comment']);

    editFieldService
      .addSpecificFieldType('WorkPackage', CombinedDateEditFieldComponent,
        'date',
        ['combinedDate', 'startDate', 'dueDate', 'date'])
      .addSpecificFieldType('Project', ProjectStatusEditFieldComponent, 'status', ['status'])
      .addSpecificFieldType('TimeEntry', PlainFormattableEditFieldComponent, 'comment', ['comment'])
      .addSpecificFieldType('TimeEntry', TimeEntryWorkPackageEditFieldComponent, 'workPackage', ['WorkPackage']);

    selectAutocompleterRegisterService.register(VersionAutocompleterComponent, 'Version');
    selectAutocompleterRegisterService.register(WorkPackageAutocompleterComponent, 'WorkPackage');
  };
}
