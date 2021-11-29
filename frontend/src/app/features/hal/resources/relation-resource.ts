

import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import idFromLink from 'core-app/features/hal/helpers/id-from-link';

export interface RelationResourceLinks {
  delete():Promise<any>;

  updateImmediately(payload:any):Promise<any>;
}

export class RelationResource extends HalResource {
  static RELATION_TYPES(includeParentChild = true):string[] {
    const types = [
      'relates',
      'duplicates',
      'duplicated',
      'blocks',
      'blocked',
      'precedes',
      'follows',
      'includes',
      'partof',
      'requires',
      'required',
    ];

    if (includeParentChild) {
      types.push('parent', 'children');
    }

    return types;
  }

  static LOCALIZED_RELATION_TYPES(includeParentchild = true) {
    const relationTypes = RelationResource.RELATION_TYPES(includeParentchild);

    return relationTypes.map((key:string) => ({ name: key, label: I18n.t(`js.relation_labels.${key}`) }));
  }

  static DEFAULT() {
    return 'relates';
  }

  // Properties
  public description:string|null;

  public type:any;

  public reverseType:string;

  // Links
  public $links:RelationResourceLinks;

  public to:WorkPackageResource;

  public from:WorkPackageResource;

  public normalizedType(workPackage:WorkPackageResource) {
    return this.denormalized(workPackage).relationType;
  }

  /**
   * Return the denormalized relation data, seeing the relation.from to be `workPackage`.
   *
   * @param workPackage
   * @return {{id, href, relationType: string, workPackageType}}
   */
  public denormalized(workPackage:WorkPackageResource):DenormalizedRelationData {
    const target = (this.to.href === workPackage.href) ? 'from' : 'to';

    return {
      target: this[target],
      targetId: this[target].id!,
      relationType: target === 'from' ? this.reverseType : this.type,
      reverseRelationType: target === 'from' ? this.type : this.reverseType,
    };
  }

  /**
   * Return whether the given work package id is involved in this relation.
   * @param wpId
   * @return {boolean}
   */
  public isInvolved(wpId:string) {
    return _.values(this.ids).indexOf(wpId.toString()) >= 0;
  }

  /**
   * Get the involved IDs, returning an object to the ids.
   */
  public get ids() {
    return {
      from: idFromLink(this.from.href!),
      to: idFromLink(this.to.href!),
    };
  }

  public updateDescription(description:string) {
    return this.$links.updateImmediately({ description });
  }

  public updateType(type:any) {
    return this.$links.updateImmediately({ type });
  }
}

export interface RelationResource extends RelationResourceLinks {}

export interface DenormalizedRelationData {
  target:WorkPackageResource;
  targetId:string;
  relationType:string;
  reverseRelationType:string;
}
