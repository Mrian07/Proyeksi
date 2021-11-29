

import { APIv3FormResource } from 'core-app/core/apiv3/forms/apiv3-form-resource';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';
import { HalPayloadHelper } from 'core-app/features/hal/schemas/hal-payload.helper';
import { GridWidgetResource } from 'core-app/features/hal/resources/grid-widget-resource';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';

export class Apiv3GridForm extends APIv3FormResource {
  /**
   * We need to override the grid widget extraction
   * to pass the correct payload to the API.
   *
   * @param resource
   * @param schema
   */
  public static extractPayload(resource:HalResource|Object, schema:SchemaResource|null = null):Object {
    if (resource instanceof HalResource && schema) {
      const grid = resource;
      const payload = HalPayloadHelper.extractPayloadFromSchema(grid, schema);

      // The widget only states the type of the widget resource but does not explain
      // the widget itself. We therefore have to do that by hand.
      if (payload.widgets) {
        payload.widgets = grid.widgets.map((widget:GridWidgetResource) => ({
          id: widget.id,
          startRow: widget.startRow,
          endRow: widget.endRow,
          startColumn: widget.startColumn,
          endColumn: widget.endColumn,
          identifier: widget.identifier,
          options: widget.options,
        }));
      }

      return payload;
    }

    return resource || {};
  }

  /**
   * Extract payload for the form from the request and optional schema.
   *
   * @param request
   * @param schema
   */
  public extractPayload(request:HalResource|Object, schema:SchemaResource|null = null) {
    return Apiv3GridForm.extractPayload(request, schema);
  }
}
