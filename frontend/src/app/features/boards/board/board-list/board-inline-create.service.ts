

import { Injectable, Injector } from '@angular/core';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { WorkPackageRelationsHierarchyService } from 'core-app/features/work-packages/components/wp-relations/wp-relations-hierarchy/wp-relations-hierarchy.service';
import { WorkPackageInlineCreateService } from 'core-app/features/work-packages/components/wp-inline-create/wp-inline-create.service';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { HalResourceService } from 'core-app/features/hal/services/hal-resource.service';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { BoardInlineAddAutocompleterComponent } from 'core-app/features/boards/board/inline-add/board-inline-add-autocompleter.component';
import { GonService } from 'core-app/core/gon/gon.service';

@Injectable()
export class BoardInlineCreateService extends WorkPackageInlineCreateService {
  constructor(readonly injector:Injector,
    protected readonly querySpace:IsolatedQuerySpace,
    protected readonly halResourceService:HalResourceService,
    protected readonly pathHelperService:PathHelperService,
    protected readonly Gon:GonService,
    protected readonly wpRelationsHierarchyService:WorkPackageRelationsHierarchyService) {
    super(injector);
  }

  /**
   * A separate reference pane for the inline create component
   */
  public readonly referenceComponentClass = BoardInlineAddAutocompleterComponent;

  /**
   * A related work package for the inline create context
   */
  public referenceTarget:WorkPackageResource|null = null;

  public get canAdd() {
    return this.authorisationService.can('work_packages', 'createWorkPackage');
  }

  public get canReference() {
    return this.authorisationService.can('work_packages', 'editWorkPackage');
  }

  /**
   * Reference button text
   */
  public readonly buttonTexts = {
    reference: this.I18n.t('js.relation_buttons.add_existing_child'),
    create: this.I18n.t('js.relation_buttons.add_new_child'),
  };
}
