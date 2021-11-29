

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { GridWidgetResource } from 'core-app/features/hal/resources/grid-widget-resource';
import { Attachable } from 'core-app/features/hal/resources/mixins/attachable-mixin';

export interface GridResourceLinks {
  update(payload:unknown):Promise<unknown>;
  updateImmediately(payload:unknown):Promise<unknown>;
  delete():Promise<unknown>;
}

export class GridBaseResource extends HalResource {
  public widgets:GridWidgetResource[];

  public options:{ [key:string]:unknown };

  public rowCount:number;

  public columnCount:number;

  public $initialize(source:any) {
    super.$initialize(source);

    this.widgets = this
      .widgets
      .map((widget:Object) => {
        const widgetResource = new GridWidgetResource(this.injector,
          widget,
          true,
          this.halInitializer,
          'GridWidget');

        widgetResource.grid = this;

        return widgetResource;
      });
  }

  readonly attachmentsBackend = true;

  public async updateAttachments():Promise<HalResource> {
    return this.attachments.$update().then(() => {
      this.states.forResource(this)!.putValue(this);
      return this.attachments;
    });
  }
}

export const GridResource = Attachable(GridBaseResource);

export interface GridResource extends Partial<GridResourceLinks>, GridBaseResource {
}
