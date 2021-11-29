

import { StateService } from '@uirouter/angular';

/**
 * Returns the path to the split view based on the current route
 *
 * @param state State service
 */
export function splitViewRoute(state:StateService):string {
  const baseRoute = state.current.data.baseRoute || '';
  return `${baseRoute}.details`;
}
