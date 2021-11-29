

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { ICKEditorContext } from 'core-app/shared/components/editor/components/ckeditor/ckeditor.types';

export class ProjectResource extends HalResource {
  public get state() {
    return this.states.projects.get(this.id!) as any;
  }

  public getEditorContext(fieldName:string):ICKEditorContext {
    if (['statusExplanation', 'description'].indexOf(fieldName) !== -1) {
      return { type: 'full', macros: 'resource' };
    }

    return { type: 'constrained' };
  }

  /**
   * Exclude the schema _link from the linkable Resources.
   */
  public $linkableKeys():string[] {
    return _.without(super.$linkableKeys(), 'schema');
  }
}
