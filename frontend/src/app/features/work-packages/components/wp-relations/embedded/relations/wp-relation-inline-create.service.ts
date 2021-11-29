

import { Injectable, Injector, OnDestroy } from '@angular/core';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { WorkPackageInlineCreateService } from 'core-app/features/work-packages/components/wp-inline-create/wp-inline-create.service';
import { WpRelationInlineAddExistingComponent } from 'core-app/features/work-packages/components/wp-relations/embedded/inline/add-existing/wp-relation-inline-add-existing.component';
import { WorkPackageRelationsService } from 'core-app/features/work-packages/components/wp-relations/wp-relations.service';
import { WpRelationInlineCreateServiceInterface } from 'core-app/features/work-packages/components/wp-relations/embedded/wp-relation-inline-create.service.interface';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';

@Injectable()
export class WpRelationInlineCreateService extends WorkPackageInlineCreateService implements WpRelationInlineCreateServiceInterface, OnDestroy {
  @InjectField() wpRelations:WorkPackageRelationsService;

  constructor(public injector:Injector) {
    super(injector);
  }

  /**
   * A separate reference pane for the inline create component
   */
  public readonly referenceComponentClass = WpRelationInlineAddExistingComponent;

  /**
   * Defines the relation type for the relations inline create
   */
  public relationType = '';

  /**
   * Add a new relation of the above type
   */
  public add(from:WorkPackageResource, toId:string):Promise<unknown> {
    return this.wpRelations.addCommonRelation(toId, this.relationType, from.id!);
  }

  /**
   * Remove a given relation
   */
  public remove(from:WorkPackageResource, to:WorkPackageResource):Promise<unknown> {
    // Find the relation matching relationType and from->to which are unique together
    const relation = this.wpRelations.find(to, from, this.relationType);

    if (relation !== undefined) {
      return this.wpRelations.removeRelation(relation);
    }
    return Promise.reject();
  }

  /**
   * A related work package for the inline create context
   */
  public referenceTarget:WorkPackageResource|null = null;

  public get canAdd() {
    return !!(this.referenceTarget && this.canCreateWorkPackages && this.referenceTarget.addRelation);
  }

  public get canReference() {
    return !!this.canAdd;
  }

  /**
   * Reference button text
   */
  public readonly buttonTexts = {
    reference: this.I18n.t('js.relation_buttons.add_existing'),
    create: this.I18n.t('js.relation_buttons.create_new'),
  };
}
