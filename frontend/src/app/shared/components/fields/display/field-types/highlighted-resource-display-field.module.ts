

import { Highlighting } from 'core-app/features/work-packages/components/wp-fast-table/builders/highlighting/highlighting.functions';
import { HighlightableDisplayField } from 'core-app/shared/components/fields/display/field-types/highlightable-display-field.module';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';

export class HighlightedResourceDisplayField extends HighlightableDisplayField {
  public render(element:HTMLElement, displayText:string):void {
    super.render(element, displayText);

    if (this.shouldHighlight) {
      this.addHighlight(element);
    }
  }

  public get value() {
    if (this.schema) {
      return this.attribute && this.attribute.name;
    }
    return null;
  }

  private addHighlight(element:HTMLElement):void {
    if (this.attribute instanceof HalResource) {
      const hlClass = Highlighting.inlineClass(this.name, this.attribute.id!);
      element.classList.add(hlClass);
    }
  }
}
