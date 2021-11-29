

import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, EventEmitter, Input, Output,
} from '@angular/core';
import { WorkPackageViewHighlightingService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-highlighting.service';
import { CardViewOrientation } from 'core-app/features/work-packages/components/wp-card-view/wp-card-view.component';
import { WorkPackageViewSortByService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-sort-by.service';
import { distinctUntilChanged, takeUntil } from 'rxjs/operators';
import { HighlightingMode } from 'core-app/features/work-packages/components/wp-fast-table/builders/highlighting/highlighting-mode.const';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { DragAndDropService } from 'core-app/shared/helpers/drag-and-drop/drag-and-drop.service';
import { WorkPackageCardDragAndDropService } from 'core-app/features/work-packages/components/wp-card-view/services/wp-card-drag-and-drop.service';
import { WorkPackagesListService } from 'core-app/features/work-packages/components/wp-list/wp-list.service';
import { WorkPackageTableConfiguration } from 'core-app/features/work-packages/components/wp-table/wp-table-configuration';
import { WorkPackageViewOutputs } from 'core-app/features/work-packages/routing/wp-view-base/event-handling/event-handler-registry';

@Component({
  selector: 'wp-grid',
  template: `
    <wp-card-view [dragOutOfHandler]="canDragOutOf"
                  [dragInto]="dragInto"
                  [cardsRemovable]="false"
                  [highlightingMode]="highlightingMode"
                  [showStatusButton]="true"
                  [orientation]="gridOrientation"
                  (onMoved)="switchToManualSorting()"
                  (selectionChanged)="selectionChanged.emit($event)"
                  (itemClicked)="itemClicked.emit($event)"
                  (stateLinkClicked)="stateLinkClicked.emit($event)"
                  [showEmptyResultsBox]="true"
                  [showInfoButton]="true"
                  [shrinkOnMobile]="true">
    </wp-card-view>

    <div *ngIf="showResizer"
         class="hidden-for-mobile hide-when-print">
      <wp-resizer [elementClass]="resizerClass"
                  [localStorageKey]="resizerStorageKey"></wp-resizer>
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
  providers: [
    DragAndDropService,
    WorkPackageCardDragAndDropService,
  ],
})
export class WorkPackagesGridComponent implements WorkPackageViewOutputs {
  @Input() public configuration:WorkPackageTableConfiguration;

  @Input() public showResizer = false;

  @Input() public resizerClass = '';

  @Input() public resizerStorageKey = '';

  @Output() selectionChanged = new EventEmitter<string[]>();

  @Output() itemClicked = new EventEmitter<{ workPackageId:string, double:boolean }>();

  @Output() stateLinkClicked = new EventEmitter<{ workPackageId:string, requestedState:string }>();

  public canDragOutOf:() => boolean;

  public dragInto:boolean;

  public gridOrientation:CardViewOrientation = 'horizontal';

  public highlightingMode:HighlightingMode = 'none';

  constructor(readonly wpTableHighlight:WorkPackageViewHighlightingService,
    readonly wpTableSortBy:WorkPackageViewSortByService,
    readonly wpList:WorkPackagesListService,
    readonly querySpace:IsolatedQuerySpace,
    readonly cdRef:ChangeDetectorRef) {
  }

  ngOnInit() {
    this.dragInto = this.configuration.dragAndDropEnabled;
    this.canDragOutOf = () => this.configuration.dragAndDropEnabled;

    this.wpTableHighlight
      .updates$()
      .pipe(
        takeUntil(this.querySpace.stopAllSubscriptions),
        distinctUntilChanged(),
      )
      .subscribe(() => {
        this.highlightingMode = this.wpTableHighlight.current.mode;
        this.cdRef.detectChanges();
      });
  }

  public switchToManualSorting() {
    const query = this.querySpace.query.value;
    if (query && this.wpTableSortBy.switchToManualSorting(query)) {
      this.wpList.save(query);
    }
  }
}
