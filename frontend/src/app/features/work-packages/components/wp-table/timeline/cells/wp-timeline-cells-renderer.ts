

import { Injector } from '@angular/core';
import { States } from 'core-app/core/states/states.service';
import { HalResourceEditingService } from 'core-app/shared/components/fields/edit/services/hal-resource-editing.service';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { WorkPackageTimelineTableController } from '../container/wp-timeline-container.directive';
import { RenderInfo } from '../wp-timeline';
import { TimelineCellRenderer } from './timeline-cell-renderer';
import { TimelineMilestoneCellRenderer } from './timeline-milestone-cell-renderer';
import { WorkPackageTimelineCell } from './wp-timeline-cell';

export class WorkPackageTimelineCellsRenderer {
  // Injections
  @InjectField() public states:States;

  @InjectField() public halEditing:HalResourceEditingService;

  public cells:{ [classIdentifier:string]:WorkPackageTimelineCell } = {};

  private cellRenderers:{ milestone:TimelineMilestoneCellRenderer, generic:TimelineCellRenderer };

  constructor(readonly injector:Injector,
    readonly wpTimeline:WorkPackageTimelineTableController) {
    this.cellRenderers = {
      milestone: new TimelineMilestoneCellRenderer(this.injector, wpTimeline),
      generic: new TimelineCellRenderer(this.injector, wpTimeline),
    };
  }

  public hasCell(wpId:string) {
    return this.getCellsFor(wpId).length > 0;
  }

  public getCellsFor(wpId:string):WorkPackageTimelineCell[] {
    return _.filter(this.cells, (cell) => cell.workPackageId === wpId) || [];
  }

  /**
   * Synchronize the currently active cells and render them all
   */
  public refreshAllCells() {
    // Create new cells and delete old ones
    this.synchronizeCells();

    // Update all cells
    _.each(this.cells, (cell) => this.refreshSingleCell(cell));
  }

  public refreshCellsFor(wpId:string) {
    _.each(this.getCellsFor(wpId), (cell) => this.refreshSingleCell(cell));
  }

  public refreshSingleCell(cell:WorkPackageTimelineCell, isDuplicatedCell?:boolean, withAlternativeLabels?:boolean) {
    const renderInfo = this.renderInfoFor(cell.workPackageId, isDuplicatedCell, withAlternativeLabels);

    if (renderInfo.workPackage) {
      cell.refreshView(renderInfo);
    }
  }

  /**
   * Synchronize the current cells:
   *
   * 1. Create new cells in workPackageIdOrder not yet tracked
   * 2. Remove old cells no longer contained.
   */
  private synchronizeCells() {
    const currentlyActive:string[] = Object.keys(this.cells);
    const newCells:string[] = [];

    _.each(this.wpTimeline.workPackageIdOrder, (renderedRow:RenderedWorkPackage) => {
      const wpId = renderedRow.workPackageId;

      // Ignore extra rows not tied to a work package
      if (!wpId) {
        return;
      }

      const state = this.states.workPackages.get(wpId);
      if (state.isPristine()) {
        return;
      }

      // As work packages may occur several times, get the unique identifier
      // to identify the cell
      const identifier = renderedRow.classIdentifier;

      // Create a cell unless we already have an active cell
      if (!this.cells[identifier]) {
        this.cells[identifier] = this.buildCell(identifier, wpId.toString());
      }

      newCells.push(identifier);
    });

    _.difference(currentlyActive, newCells).forEach((identifier:string) => {
      this.cells[identifier].clear();
      delete this.cells[identifier];
    });
  }

  private buildCell(classIdentifier:string, workPackageId:string) {
    return new WorkPackageTimelineCell(
      this.injector,
      this.wpTimeline,
      this.cellRenderers,
      this.renderInfoFor(workPackageId),
      classIdentifier,
      workPackageId,
    );
  }

  private renderInfoFor(wpId:string, isDuplicatedCell?:boolean, withAlternativeLabels?:boolean):RenderInfo {
    const wp = this.states.workPackages.get(wpId).value!;
    return {
      viewParams: this.wpTimeline.viewParameters,
      workPackage: wp,
      change: this.halEditing.changeFor(wp),
      isDuplicatedCell,
      withAlternativeLabels,
    };
  }

  public buildCellsAndRenderOnRow(workPackageIds:string[], rowClassIdentifier:string, isDuplicatedCell?:boolean):WorkPackageTimelineCell[] {
    const cells = workPackageIds.map((workPackageId) => this.buildCell(rowClassIdentifier, workPackageId));

    cells.forEach((cell:WorkPackageTimelineCell) => this.refreshSingleCell(cell, isDuplicatedCell, true));

    return cells;
  }
}
