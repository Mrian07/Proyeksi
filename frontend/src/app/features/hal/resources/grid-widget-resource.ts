

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { GridResource } from 'core-app/features/hal/resources/grid-resource';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { HalResourceService } from 'core-app/features/hal/services/hal-resource.service';

export class GridWidgetResource extends HalResource {
  @InjectField() protected halResource:HalResourceService;

  public identifier:string;

  public startRow:number;

  public endRow:number;

  public startColumn:number;

  public endColumn:number;

  public options:{ [key:string]:unknown };

  public get height() {
    return this.endRow - this.startRow;
  }

  public get width() {
    return this.endColumn - this.startColumn;
  }

  public grid:GridResource;

  public get schema():SchemaResource {
    return this.halResource.createHalResource({ _type: 'Schema' }, true);
  }
}
