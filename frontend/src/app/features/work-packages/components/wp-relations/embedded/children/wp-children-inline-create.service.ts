

import { Injectable, Injector } from '@angular/core';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { WorkPackageRelationsHierarchyService } from 'core-app/features/work-packages/components/wp-relations/wp-relations-hierarchy/wp-relations-hierarchy.service';
import { WorkPackageInlineCreateService } from 'core-app/features/work-packages/components/wp-inline-create/wp-inline-create.service';
import { WpRelationInlineCreateServiceInterface } from 'core-app/features/work-packages/components/wp-relations/embedded/wp-relation-inline-create.service.interface';
import { WpRelationInlineAddExistingComponent } from 'core-app/features/work-packages/components/wp-relations/embedded/inline/add-existing/wp-relation-inline-add-existing.component';
import { SchemaCacheService } from 'core-app/core/schemas/schema-cache.service';

@Injectable()
export class WpChildrenInlineCreateService extends WorkPackageInlineCreateService implements WpRelationInlineCreateServiceInterface {
  constructor(readonly injector:Injector,
    protected readonly wpRelationsHierarchyService:WorkPackageRelationsHierarchyService,
    protected readonly schemaCache:SchemaCacheService) {
    super(injector);
  }

  /**
   * A separate reference pane for the inline create component
   */
  public readonly referenceComponentClass = WpRelationInlineAddExistingComponent;

  /**
   * Define the reference type
   */
  public relationType = 'children';

  /**
   * Add a new relation of the above type
   */
  public add(from:WorkPackageResource, toId:string):Promise<unknown> {
    return this.wpRelationsHierarchyService.addExistingChildWp(from, toId);
  }

  /**
   * Remove a given relation
   */
  public remove(from:WorkPackageResource, to:WorkPackageResource):Promise<unknown> {
    return this.wpRelationsHierarchyService.removeChild(to);
  }

  /**
   * A related work package for the inline create context
   */
  public referenceTarget:WorkPackageResource|null = null;

  public get canAdd() {
    return !!(this.referenceTarget && this.canCreateWorkPackages && this.canAddChild);
  }

  public get canReference() {
    return !!(this.referenceTarget && this.canAddChild);
  }

  public get canAddChild() {
    return this.schema && !this.schema.isMilestone && this.referenceTarget!.changeParent;
  }

  /**
   * Reference button text
   */
  public readonly buttonTexts = {
    reference: this.I18n.t('js.relation_buttons.add_existing_child'),
    create: this.I18n.t('js.relation_buttons.add_new_child'),
  };

  private get schema() {
    return this.referenceTarget && this.schemaCache.of(this.referenceTarget);
  }
}
