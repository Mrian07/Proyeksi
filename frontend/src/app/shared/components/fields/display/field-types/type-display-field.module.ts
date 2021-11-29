

import { HighlightedResourceDisplayField } from 'core-app/shared/components/fields/display/field-types/highlighted-resource-display-field.module';

export class TypeDisplayField extends HighlightedResourceDisplayField {
  // Type will always be highlighted
  public get shouldHighlight() {
    return true;
  }
}
