

import { Component, Input, OnInit } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { WorkPackageRelationsHierarchyService } from 'core-app/features/work-packages/components/wp-relations/wp-relations-hierarchy/wp-relations-hierarchy.service';
import { take } from 'rxjs/operators';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

@Component({
  selector: 'wp-relations-hierarchy',
  templateUrl: './wp-relations-hierarchy.template.html',
})
export class WorkPackageRelationsHierarchyComponent extends UntilDestroyedMixin implements OnInit {
  @Input() public workPackage:WorkPackageResource;

  @Input() public relationType:string;

  public showEditForm = false;

  public workPackagePath:string;

  public canHaveChildren:boolean;

  public canModifyHierarchy:boolean;

  public canAddRelation:boolean;

  public childrenQueryProps:any;

  constructor(protected wpRelationsHierarchyService:WorkPackageRelationsHierarchyService,
    protected apiV3Service:APIV3Service,
    protected PathHelper:PathHelperService,
    readonly I18n:I18nService) {
    super();
  }

  public text = {
    parentHeadline: this.I18n.t('js.relations_hierarchy.parent_headline'),
    childrenHeadline: this.I18n.t('js.relations_hierarchy.children_headline'),
  };

  ngOnInit() {
    this.workPackagePath = this.PathHelper.workPackagePath(this.workPackage.id!);
    this.canModifyHierarchy = !!this.workPackage.changeParent;
    this.canAddRelation = !!this.workPackage.addRelation;

    this.childrenQueryProps = {
      filters: JSON.stringify([{ parent: { operator: '=', values: [this.workPackage.id] } }]),
      'columns[]': ['id', 'type', 'subject', 'status'],
      showHierarchies: false,
    };

    this
      .apiV3Service
      .work_packages
      .id(this.workPackage)
      .requireAndStream()
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe((wp:WorkPackageResource) => {
        this.workPackage = wp;

        const parentId = this.workPackage.parent?.id?.toString();

        if (parentId) {
          this
            .apiV3Service
            .work_packages
            .id(parentId)
            .get()
            .pipe(
              take(1),
            )
            .subscribe((parent:WorkPackageResource) => {
              this.workPackage.parent = parent;
            });
        }
      });
  }
}
