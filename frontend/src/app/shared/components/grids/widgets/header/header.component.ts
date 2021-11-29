

import {
  ChangeDetectionStrategy, Component, EventEmitter, Input, Output,
} from '@angular/core';
import { GridAreaService } from 'core-app/shared/components/grids/grid/area.service';

@Component({
  selector: 'widget-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.sass'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class WidgetHeaderComponent {
  @Input() name:string;

  @Input() editable = true;

  @Output() onRenamed = new EventEmitter<string>();

  constructor(readonly layout:GridAreaService) {

  }

  public renamed(name:string) {
    this.onRenamed.emit(name);
  }

  public get isRenameable() {
    return this.editable && this.layout.isEditable;
  }
}
