

import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { WorkPackageInlineCreateService } from 'core-app/features/work-packages/components/wp-inline-create/wp-inline-create.service';

export interface WpRelationInlineCreateServiceInterface extends WorkPackageInlineCreateService {

  /**
   * Defines the relation type for the relations inline create
   */
  relationType:string;

  /**
   * Add a new relation of the above type
   */
  add(from:WorkPackageResource, toId:string):Promise<unknown>;
}
