import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormattableControlComponent } from 'core-app/shared/components/dynamic-forms/components/dynamic-inputs/formattable-textarea-input/components/formattable-control/formattable-control.component';
import { ProyeksiappEditorModule } from 'core-app/shared/components/editor/proyeksiapp-editor.module';
import { FormattableEditFieldModule } from 'core-app/shared/components/fields/edit/field-types/formattable-edit-field/formattable-edit-field.module';

@NgModule({
  declarations: [
    FormattableControlComponent,
  ],
  imports: [
    CommonModule,
    ProyeksiappEditorModule,
    FormattableEditFieldModule,
  ],
  exports: [
    FormattableControlComponent,
  ],
})
export class FormattableControlModule { }
