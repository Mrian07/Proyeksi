

import { HighlightingMode } from 'core-app/features/work-packages/components/wp-fast-table/builders/highlighting/highlighting-mode.const';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';

export interface WorkPackageViewHighlight {
  mode:HighlightingMode;
  selectedAttributes?:HalResource[]|undefined;
}
