

import { HalResource } from 'core-app/features/hal/resources/hal-resource';

export class TimeEntryResource extends HalResource {
  public get state() {
    return this.states.timeEntries.get(this.id!) as any;
  }

  /**
   * Exclude the schema _link from the linkable Resources.
   */
  public $linkableKeys():string[] {
    return _.without(super.$linkableKeys(), 'schema');
  }
}
