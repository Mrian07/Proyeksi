

import {
  Component, ElementRef, OnInit, ViewChild,
} from '@angular/core';
import { NgSelectComponent } from '@ng-select/ng-select';

type SelectItem = { label:string, value:string, selected?:boolean };

export const autocompleteSelectDecorationSelector = 'autocomplete-select-decoration';

@Component({
  template: `
    <ng-select [items]="options"
               [labelForId]="labelForId"
               bindLabel="label"
               [multiple]="multiselect"
               [virtualScroll]="true"
               [ngModel]="selected"
               appendTo="body"
               placeholder="Please select"
               (ngModelChange)="updateSelection($event)">
      <ng-template ng-option-tmp let-item="item" let-index="index">
        {{ item.label }}
      </ng-template>
    </ng-select>
  `,
  selector: autocompleteSelectDecorationSelector,
})
export class AutocompleteSelectDecorationComponent implements OnInit {
  @ViewChild(NgSelectComponent) public ngSelectComponent:NgSelectComponent;

  public options:SelectItem[];

  /** Whether we're a multiselect */
  public multiselect = false;

  /** Get the selected options */
  public selected:SelectItem|SelectItem[];

  /** The input name we're syncing selections to */
  private syncInputFieldName:string;

  /** The input id used for label */
  public labelForId:string;

  constructor(protected elementRef:ElementRef) {
  }

  ngOnInit() {
    const element = this.elementRef.nativeElement;

    // Set options
    this.multiselect = element.dataset.multiselect === 'true';
    this.labelForId = element.dataset.inputId!;

    // Get the sync target
    this.syncInputFieldName = element.dataset.inputName;
    // Add Rails multiple identifier if multiselect
    if (this.multiselect) {
      this.syncInputFieldName += '[]';
    }

    // Prepare and build the options
    // Expected array of objects with id, name, select
    const data:SelectItem[] = JSON.parse(element.dataset.options);

    // Set initial selection
    this.setInitialSelection(data);

    if (!this.multiselect) {
      this.selected = (this.selected as SelectItem[])[0];
    }

    this.options = data;

    // Unhide the parent
    element.parentElement.hidden = false;
  }

  setInitialSelection(data:SelectItem[]) {
    this.updateSelection(data.filter((element) => element.selected));
  }

  updateSelection(items:SelectItem|SelectItem[]) {
    this.selected = items;
    items = _.castArray(items);

    this.removeCurrentSyncedFields();
    items.forEach((el:SelectItem) => {
      this.createSyncedField(el.value);
    });
  }

  createSyncedField(value:string) {
    const element = jQuery(this.elementRef.nativeElement);
    element
      .parent()
      .append(`<input type="hidden" name="${this.syncInputFieldName || ''}" value="${value}" />`);
  }

  removeCurrentSyncedFields() {
    const element = jQuery(this.elementRef.nativeElement);
    element
      .parent()
      .find(`input[name="${this.syncInputFieldName}"]`)
      .remove();
  }
}
