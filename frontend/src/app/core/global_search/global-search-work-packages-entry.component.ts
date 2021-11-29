

import { Component } from '@angular/core';

export const globalSearchWorkPackagesSelectorEntry = 'global-search-work-packages-entry';

/**
 * An entry component to be rendered by Rails which opens an isolated query space
 * for the work package search embedded table.
 */
@Component({
  selector: globalSearchWorkPackagesSelectorEntry,
  template: `
    <ng-container wp-isolated-query-space>
      <global-search-work-packages></global-search-work-packages>
    </ng-container>
  `,
})
export class GlobalSearchWorkPackagesEntryComponent {
}
