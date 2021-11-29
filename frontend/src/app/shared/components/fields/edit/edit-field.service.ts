

import { Injectable } from '@angular/core';
import { AbstractFieldService, IFieldType } from 'core-app/shared/components/fields/field.service';
import { EditFieldComponent } from 'core-app/shared/components/fields/edit/edit-field.component';

export interface IEditFieldType extends IFieldType<EditFieldComponent> {
  new():EditFieldComponent;
}

@Injectable({ providedIn: 'root' })
export class EditFieldService extends AbstractFieldService<EditFieldComponent, IEditFieldType> {
}
