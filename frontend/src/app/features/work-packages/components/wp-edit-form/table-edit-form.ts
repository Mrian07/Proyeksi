

import { Injector } from '@angular/core';
import { Subscription } from 'rxjs';
import { States } from 'core-app/core/states/states.service';
import { IFieldSchema } from 'core-app/shared/components/fields/field.base';

import { EditFieldHandler } from 'core-app/shared/components/fields/edit/editing-portal/edit-field-handler';
import { WorkPackageViewColumnsService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-columns.service';
import { FocusHelperService } from 'core-app/shared/directives/focus/focus-helper';
import { EditingPortalService } from 'core-app/shared/components/fields/edit/editing-portal/editing-portal-service';
import { CellBuilder, editCellContainer, tdClassName } from 'core-app/features/work-packages/components/wp-fast-table/builders/cell-builder';
import { WorkPackageTable } from 'core-app/features/work-packages/components/wp-fast-table/wp-fast-table';
import { EditForm } from 'core-app/shared/components/fields/edit/edit-form/edit-form';
import { editModeClassName } from 'core-app/shared/components/fields/edit/edit-field.component';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

export const activeFieldContainerClassName = 'inline-edit--active-field';
export const activeFieldClassName = 'inline-edit--field';

export class TableEditForm extends EditForm<WorkPackageResource> {
  @InjectField() public wpTableColumns:WorkPackageViewColumnsService;

  @InjectField() public apiV3Service!:APIV3Service;

  @InjectField() public states:States;

  @InjectField() public FocusHelper:FocusHelperService;

  @InjectField() public editingPortalService:EditingPortalService;

  // Use cell builder to reset edit fields
  private cellBuilder = new CellBuilder(this.injector);

  // Subscription
  private resourceSubscription:Subscription = this
    .apiV3Service
    .work_packages
    .id(this.workPackageId)
    .requireAndStream()
    .subscribe((wp) => this.resource = wp);

  constructor(public injector:Injector,
    public table:WorkPackageTable,
    public workPackageId:string,
    public classIdentifier:string) {
    super(injector);
  }

  destroy() {
    this.resourceSubscription.unsubscribe();
  }

  public findContainer(fieldName:string):JQuery {
    return this.rowContainer.find(`.${tdClassName}.${fieldName} .${editCellContainer}`).first();
  }

  public findCell(fieldName:string) {
    return this.rowContainer.find(`.${tdClassName}.${fieldName}`).first();
  }

  public activateField(form:EditForm, schema:IFieldSchema, fieldName:string, errors:string[]):Promise<EditFieldHandler> {
    return this.waitForContainer(fieldName)
      .then((cell) => {
        // Forcibly set the width since the edit field may otherwise
        // be given more width. Thereby preserve a minimum width of 150.
        // To avoid flickering content, the padding is removed, too.
        const td = this.findCell(fieldName);
        td.addClass(editModeClassName);
        let width = parseInt(td.css('width'));
        width = width > 150 ? width - 10 : 150;
        td.css('max-width', `${width}px`);
        td.css('width', `${width}px`);

        return this.editingPortalService.create(
          cell,
          this.injector,
          form,
          schema,
          fieldName,
          errors,
        );
      });
  }

  public reset(fieldName:string, focus?:boolean) {
    const cell = this.findContainer(fieldName);
    const td = this.findCell(fieldName);

    if (cell.length) {
      this.findCell(fieldName).css('width', '');
      this.findCell(fieldName).css('max-width', '');
      this.cellBuilder.refresh(cell[0], this.resource, fieldName);
      td.removeClass(editModeClassName);

      if (focus) {
        this.FocusHelper.focusElement(cell);
      }
    }
  }

  public requireVisible(fieldName:string):Promise<any> {
    this.wpTableColumns.addColumn(fieldName);
    return this.waitForContainer(fieldName);
  }

  protected focusOnFirstError():void {
    // Focus the first field that is erroneous
    jQuery(this.table.tableAndTimelineContainer)
      .find(`.${activeFieldContainerClassName}.-error .${activeFieldClassName}`)
      .first()
      .trigger('focus');
  }

  /**
   * Load the resource form to get the current field schema with all
   * values loaded.
   * @param fieldName
   */
  protected loadFieldSchema(fieldName:string, noWarnings = false):Promise<IFieldSchema> {
    // We need to handle start/due date cases like they were combined dates
    if (['startDate', 'dueDate', 'date'].includes(fieldName)) {
      fieldName = 'combinedDate';
    }

    return super.loadFieldSchema(fieldName, noWarnings);
  }

  // Ensure the given field is visible.
  // We may want to look into MutationObserver if we need this in several places.
  private waitForContainer(fieldName:string):Promise<HTMLElement> {
    return new Promise<HTMLElement>((resolve, reject) => {
      const interval = setInterval(() => {
        const container = this.findContainer(fieldName);

        if (container.length > 0) {
          clearInterval(interval);
          resolve(container[0]);
        }
      }, 100);
    });
  }

  private get rowContainer() {
    return jQuery(this.table.tableAndTimelineContainer).find(`.${this.classIdentifier}-table`);
  }
}
