

const cssClassRowHovered = 'row-hovered';

export class WpTableHoverSync {
  private lastHoveredElement:Element | null = null;

  private eventListener = (evt:MouseEvent) => {
    const target = evt.target as Element|null;
    if (target && target !== this.lastHoveredElement) {
      this.handleHover(target);
    }
    this.lastHoveredElement = target;
  };

  constructor(private tableAndTimeline:JQuery) {
  }

  activate() {
    window.addEventListener('mousemove', this.eventListener, { passive: true });
  }

  deactivate() {
    window.removeEventListener('mousemove', this.eventListener);
    this.removeAllHoverClasses();
  }

  private locateHoveredTableRow(child:JQuery):Element | null {
    const parent = child.closest('tr');
    if (parent.length === 0) {
      return null;
    }
    return parent[0];
  }

  private locateHoveredTimelineRow(child:JQuery):Element | null {
    const parent = child.closest('div.wp-timeline-cell');
    if (parent.length === 0) {
      return null;
    }
    return parent[0];
  }

  private handleHover(element:Element) {
    const $element = jQuery(element) as JQuery;
    const parentTableRow = this.locateHoveredTableRow($element);
    const parentTimelineRow = this.locateHoveredTimelineRow($element);

    // remove all hover classes if cursor does not hover a row
    if (parentTableRow === null && parentTimelineRow === null) {
      this.removeAllHoverClasses();
      return;
    }

    this.removeOldAndAddNewHoverClass(parentTableRow, parentTimelineRow);
  }

  private extractWorkPackageId(row:Element):number {
    return parseInt(row.getAttribute('data-work-package-id')!);
  }

  private removeOldAndAddNewHoverClass(parentTableRow:Element | null, parentTimelineRow:Element | null) {
    const hovered = parentTableRow !== null ? parentTableRow : parentTimelineRow;
    const wpId = this.extractWorkPackageId(hovered!);

    const tableRow:JQuery = this.tableAndTimeline.find(`tr.wp-row-${wpId}`).first();
    const timelineRow:JQuery = this.tableAndTimeline.find(`div.wp-row-${wpId}`).length
      ? this.tableAndTimeline.find(`div.wp-row-${wpId}`).first()
      : this.tableAndTimeline.find(`div.wp-ancestor-row-${wpId}`).first();

    requestAnimationFrame(() => {
      this.removeAllHoverClasses();
      timelineRow.addClass(cssClassRowHovered);
      tableRow.addClass(cssClassRowHovered);
    });
  }

  private removeAllHoverClasses() {
    this.tableAndTimeline
      .find(`.${cssClassRowHovered}`)
      .removeClass(cssClassRowHovered);
  }
}
