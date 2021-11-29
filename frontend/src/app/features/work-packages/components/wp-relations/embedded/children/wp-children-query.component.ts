

import { Component, Input, OnInit } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { UrlParamsHelperService } from 'core-app/features/work-packages/components/wp-query/url-params-helper';
import { WorkPackageRelationsHierarchyService } from 'core-app/features/work-packages/components/wp-relations/wp-relations-hierarchy/wp-relations-hierarchy.service';
import { OpUnlinkTableAction } from 'core-app/features/work-packages/components/wp-table/table-actions/actions/unlink-table-action';
import { OpTableActionFactory } from 'core-app/features/work-packages/components/wp-table/table-actions/table-action';
import { WorkPackageInlineCreateService } from 'core-app/features/work-packages/components/wp-inline-create/wp-inline-create.service';
import { WorkPackageRelationQueryBase } from 'core-app/features/work-packages/components/wp-relations/embedded/wp-relation-query.base';
import { WpChildrenInlineCreateService } from 'core-app/features/work-packages/components/wp-relations/embedded/children/wp-children-inline-create.service';
import { filter } from 'rxjs/operators';
import { QueryResource } from 'core-app/features/hal/resources/query-resource';
import { HalEventsService } from 'core-app/features/hal/services/hal-events.service';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { GroupDescriptor } from 'core-app/features/work-packages/components/wp-single-view/wp-single-view.component';
import idFromLink from 'core-app/features/hal/helpers/id-from-link';

@Component({
  selector: 'wp-children-query',
  templateUrl: '../wp-relation-query.html',
  providers: [
    { provide: WorkPackageInlineCreateService, useClass: WpChildrenInlineCreateService },
  ],
})
export class WorkPackageChildrenQueryComponent extends WorkPackageRelationQueryBase implements OnInit {
  @Input() public workPackage:WorkPackageResource;

  @Input() public query:QueryResource;

  /** An optional group descriptor if we're rendering on the single view */
  @Input() public group?:GroupDescriptor;

  @Input() public addExistingChildEnabled = false;

  public idFromLink = idFromLink;

  public tableActions:OpTableActionFactory[] = [
    OpUnlinkTableAction.factoryFor(
      'remove-child-action',
      this.I18n.t('js.relation_buttons.remove_child'),
      (child:WorkPackageResource) => {
        if (this.embeddedTable) {
          this.embeddedTable.loadingIndicator = this.wpRelationsHierarchyService.removeChild(child);
        }
      },
      (child:WorkPackageResource) => !!child.changeParent,
    ),
  ];

  constructor(protected wpRelationsHierarchyService:WorkPackageRelationsHierarchyService,
    protected PathHelper:PathHelperService,
    protected wpInlineCreate:WorkPackageInlineCreateService,
    protected halEvents:HalEventsService,
    protected apiV3Service:APIV3Service,
    protected queryUrlParamsHelper:UrlParamsHelperService,
    readonly I18n:I18nService) {
    super(queryUrlParamsHelper);
  }

  ngOnInit() {
    // Set reference target and reference class
    this.wpInlineCreate.referenceTarget = this.workPackage;

    // Set up the query props
    this.queryProps = this.buildQueryProps();

    // Fire event that children were added
    this.wpInlineCreate.newInlineWorkPackageCreated
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe((toId:string) => {
        this.halEvents.push(this.workPackage, {
          eventType: 'association',
          relatedWorkPackage: toId,
          relationType: 'child',
        });
      });

    // Refresh table when work package is refreshed
    this
      .apiV3Service
      .work_packages
      .id(this.workPackage)
      .observe()
      .pipe(
        filter(() => !!this.embeddedTable?.isInitialized),
        this.untilDestroyed(),
      )
      .subscribe(() => this.refreshTable());
  }
}