    

import { Component, ElementRef } from '@angular/core';
import { WorkPackageTableConfigurationObject } from 'core-app/features/work-packages/components/wp-table/wp-table-configuration';

export const wpEmbeddedTableMacroSelector = 'macro.embedded-table';

@Component({
  selector: wpEmbeddedTableMacroSelector,
  template: `
    <wp-embedded-table-entry [queryProps]="queryProps"
                             [configuration]="configuration">
    </wp-embedded-table-entry>
  `,
})
export class EmbeddedTablesMacroComponent {
  // noinspection JSUnusedGlobalSymbols
  public queryProps:any;

  public configuration:WorkPackageTableConfigurationObject = {
    actionsColumnEnabled: false,
    columnMenuEnabled: false,
    contextMenuEnabled: false,
  };

  constructor(readonly elementRef:ElementRef) {
  }

  ngOnInit() {
    const element = this.elementRef.nativeElement;
    this.queryProps = JSON.parse(element.dataset.queryProps);
  }
}
