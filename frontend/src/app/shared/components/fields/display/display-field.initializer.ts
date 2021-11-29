

import { DisplayFieldService } from 'core-app/shared/components/fields/display/display-field.service';
import { TextDisplayField } from 'core-app/shared/components/fields/display/field-types/text-display-field.module';
import { FloatDisplayField } from 'core-app/shared/components/fields/display/field-types/float-display-field.module';
import { IntegerDisplayField } from 'core-app/shared/components/fields/display/field-types/integer-display-field.module';
import { ResourceDisplayField } from 'core-app/shared/components/fields/display/field-types/resource-display-field.module';
import { ResourcesDisplayField } from 'core-app/shared/components/fields/display/field-types/resources-display-field.module';
import { FormattableDisplayField } from 'core-app/shared/components/fields/display/field-types/formattable-display-field.module';
import { DurationDisplayField } from 'core-app/shared/components/fields/display/field-types/duration-display-field.module';
import { DateDisplayField } from 'core-app/shared/components/fields/display/field-types/date-display-field.module';
import { DateTimeDisplayField } from 'core-app/shared/components/fields/display/field-types/datetime-display-field.module';
import { BooleanDisplayField } from 'core-app/shared/components/fields/display/field-types/boolean-display-field.module';
import { ProgressDisplayField } from 'core-app/shared/components/fields/display/field-types/progress-display-field.module';
import { WorkPackageDisplayField } from 'core-app/shared/components/fields/display/field-types/work-package-display-field.module';
import { WorkPackageSpentTimeDisplayField } from 'core-app/shared/components/fields/display/field-types/wp-spent-time-display-field.module';
import { IdDisplayField } from 'core-app/shared/components/fields/display/field-types/id-display-field.module';
import { HighlightedResourceDisplayField } from 'core-app/shared/components/fields/display/field-types/highlighted-resource-display-field.module';
import { TypeDisplayField } from 'core-app/shared/components/fields/display/field-types/type-display-field.module';
import { UserDisplayField } from 'core-app/shared/components/fields/display/field-types/user-display-field.module';
import { MultipleUserFieldModule } from 'core-app/shared/components/fields/display/field-types/multiple-user-display-field.module';
import { WorkPackageIdDisplayField } from 'core-app/shared/components/fields/display/field-types/wp-id-display-field.module';
import { ProjectStatusDisplayField } from 'core-app/shared/components/fields/display/field-types/project-status-display-field.module';
import { PlainFormattableDisplayField } from 'core-app/shared/components/fields/display/field-types/plain-formattable-display-field.module';
import { LinkedWorkPackageDisplayField } from 'core-app/shared/components/fields/display/field-types/linked-work-package-display-field.module';
import { CombinedDateDisplayField } from 'core-app/shared/components/fields/display/field-types/combined-date-display.field';

export function initializeCoreDisplayFields(displayFieldService:DisplayFieldService) {
  return () => {
    displayFieldService.defaultFieldType = 'text';
    displayFieldService
      .addFieldType(TextDisplayField, 'text', ['String'])
      .addFieldType(FloatDisplayField, 'float', ['Float'])
      .addFieldType(IntegerDisplayField, 'integer', ['Integer'])
      .addFieldType(HighlightedResourceDisplayField, 'highlight', [
        'Status',
        'Priority',
      ])
      .addFieldType(TypeDisplayField, 'type', ['Type'])
      .addFieldType(ResourceDisplayField, 'resource', [
        'Project',
        'TimeEntriesActivity',
        'Version',
        'Category',
        'CustomOption'])
      .addFieldType(ResourcesDisplayField, 'resources', ['[]CustomOption'])
      .addFieldType(MultipleUserFieldModule, 'users', ['[]User'])
      .addFieldType(FormattableDisplayField, 'formattable', ['Formattable'])
      .addFieldType(DurationDisplayField, 'duration', ['Duration'])
      .addFieldType(DateDisplayField, 'date', ['Date'])
      .addFieldType(DateTimeDisplayField, 'datetime', ['DateTime'])
      .addFieldType(BooleanDisplayField, 'boolean', ['Boolean'])
      .addFieldType(ProgressDisplayField, 'progress', ['percentageDone'])
      .addFieldType(LinkedWorkPackageDisplayField, 'work_package', ['WorkPackage'])
      .addFieldType(IdDisplayField, 'id', ['id'])
      .addFieldType(UserDisplayField, 'user', ['User']);

    displayFieldService
      .addSpecificFieldType('WorkPackage', WorkPackageIdDisplayField, 'id', ['id'])
      .addSpecificFieldType('WorkPackage', WorkPackageSpentTimeDisplayField, 'spentTime', ['spentTime'])
      .addSpecificFieldType('WorkPackage', CombinedDateDisplayField, 'combinedDate', ['combinedDate'])
      .addSpecificFieldType('TimeEntry', PlainFormattableDisplayField, 'comment', ['comment'])
      .addSpecificFieldType('Project', ProjectStatusDisplayField, 'status', ['status'])
      .addSpecificFieldType('TimeEntry', WorkPackageDisplayField, 'work_package', ['workPackage']);
  };
}
