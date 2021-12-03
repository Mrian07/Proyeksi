import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormattableEditFieldComponent } from 'core-app/shared/components/fields/edit/field-types/formattable-edit-field/formattable-edit-field.component';
import { ProyeksiappEditorModule } from 'core-app/shared/components/editor/proyeksiapp-editor.module';
import { EditFieldControlsModule } from 'core-app/shared/components/fields/edit/field-controls/edit-field-controls.module';

@NgModule({
  declarations: [
    FormattableEditFieldComponent,
  ],
  imports: [
    CommonModule,
    ProyeksiappEditorModule,
    EditFieldControlsModule,
  ],
  exports: [
    FormattableEditFieldComponent,
  ],
})
export class FormattableEditFieldModule { }
