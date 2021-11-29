

import { DisplayField } from 'core-app/shared/components/fields/display/display-field.module';
import { WorkPackageViewHighlightingService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-highlighting.service';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';

export class HighlightableDisplayField extends DisplayField {
  /** Optionally test if we can inject highlighting service */
  @InjectField(WorkPackageViewHighlightingService, null) viewHighlighting:WorkPackageViewHighlightingService;

  // DisplayFieldRenderer.attributeName returns the 'date' name for the
  // 'dueDate' field because it is its schema.mappedName (that allows to display
  // the correct input type). In the query.highlightedAttributes (used to decide
  // if a field is highlighted) the attribute has the name 'dueDate', so we need
  // to return the original name to get it highlighted.
  get highlightName() {
    if (this.name === 'date') {
      return 'dueDate';
    }
    return this.name;
  }

  public get shouldHighlight() {
    if (this.context.options.colorize === false) {
      return false;
    }

    const shouldHighlight = !!this.viewHighlighting && this.viewHighlighting.shouldHighlightInline(this.highlightName);

    return this.context.container !== 'table' || shouldHighlight;
  }
}
