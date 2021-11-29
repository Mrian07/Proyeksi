

import {
  ChangeDetectionStrategy,
  ChangeDetectorRef,
  Component,
  EventEmitter,
  Input,
  OnInit,
  Output,
} from '@angular/core';
import { TypeBannerService } from 'core-app/features/admin/types/type-banner.service';

@Component({
  selector: 'op-group-edit-in-place',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './group-edit-in-place.html',
})
export class GroupEditInPlaceComponent implements OnInit {
  @Input() public placeholder = '';

  @Input() public name:string;

  @Output() public onValueChange = new EventEmitter<string>();

  public editing = false;

  public editedName:string;

  constructor(private bannerService:TypeBannerService,
    protected readonly cdRef:ChangeDetectorRef) {
  }

  ngOnInit():void {
    this.editedName = this.name;

    if (!this.name || this.name.length === 0) {
      // Group name is empty so open in editing mode straight away.
      this.startEditing();
    }
  }

  startEditing() {
    this.bannerService.conditional(
      () => this.bannerService.showEEOnlyHint(),
      () => {
        this.editing = true;
      },
    );
  }

  saveEdition(event:FocusEvent) {
    this.leaveEditingMode();
    this.name = this.editedName.trim();

    this.cdRef.detectChanges();

    if (this.name !== '') {
      this.onValueChange.emit(this.name);
    }

    // Ensure form is not submitted.
    event.preventDefault();
    event.stopPropagation();
    return false;
  }

  reset() {
    this.editing = false;
    this.editedName = this.name;
  }

  leaveEditingMode() {
    // Only leave Editing mode if name not empty.
    if (this.editedName != null && this.editedName.trim().length > 0) {
      this.editing = false;
    }
  }
}
