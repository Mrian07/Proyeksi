

import {
  Component, EventEmitter, Input, Output,
} from '@angular/core';
import { EditFieldComponent } from 'core-app/shared/components/fields/edit/edit-field.component';

@Component({
  selector: 'edit-field-controls',
  templateUrl: './edit-field-controls.component.html',
})
export class EditFieldControlsComponent {
  @Input() public cancelTitle:string;

  @Input() public saveTitle:string;

  @Input('fieldController') public field:EditFieldComponent;

  @Output() public onSave = new EventEmitter<void>();

  @Output() public onCancel = new EventEmitter<void>();

  public save() {
    this.onSave.emit();
  }

  public cancel() {
    this.onCancel.emit();
  }
}
