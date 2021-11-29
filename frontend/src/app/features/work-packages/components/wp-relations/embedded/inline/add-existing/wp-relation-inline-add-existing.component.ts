

import { Component, Inject } from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageInlineCreateService } from 'core-app/features/work-packages/components/wp-inline-create/wp-inline-create.service';
import { WorkPackageInlineCreateComponent } from 'core-app/features/work-packages/components/wp-inline-create/wp-inline-create.component';
import { WorkPackageRelationsService } from 'core-app/features/work-packages/components/wp-relations/wp-relations.service';
import { WpRelationInlineCreateServiceInterface } from 'core-app/features/work-packages/components/wp-relations/embedded/wp-relation-inline-create.service.interface';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { UrlParamsHelperService } from 'core-app/features/work-packages/components/wp-query/url-params-helper';
import { RelationResource } from 'core-app/features/hal/resources/relation-resource';
import { HalEventsService } from 'core-app/features/hal/services/hal-events.service';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { ApiV3Filter } from 'core-app/shared/helpers/api-v3/api-v3-filter-builder';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';

@Component({
  templateUrl: './wp-relation-inline-add-existing.component.html',
})
export class WpRelationInlineAddExistingComponent {
  public selectedWpId:string;

  public isDisabled = false;

  public queryFilters = this.buildQueryFilters();

  public text = {
    abort: this.I18n.t('js.relation_buttons.abort'),
  };

  constructor(protected readonly parent:WorkPackageInlineCreateComponent,
    @Inject(WorkPackageInlineCreateService) protected readonly wpInlineCreate:WpRelationInlineCreateServiceInterface,
    protected apiV3Service:APIV3Service,
    protected wpRelations:WorkPackageRelationsService,
    protected notificationService:WorkPackageNotificationService,
    protected halEvents:HalEventsService,
    protected urlParamsHelper:UrlParamsHelperService,
    protected querySpace:IsolatedQuerySpace,
    protected readonly I18n:I18nService) {
  }

  public addExisting() {
    if (_.isNil(this.selectedWpId)) {
      return;
    }

    const newRelationId = this.selectedWpId;
    this.isDisabled = true;

    this.wpInlineCreate.add(this.workPackage, newRelationId)
      .then(() => {
        this
          .apiV3Service
          .work_packages
          .id(this.workPackage)
          .refresh();

        this.halEvents.push(this.workPackage, {
          eventType: 'association',
          relatedWorkPackage: newRelationId,
          relationType: this.relationType,
        });

        this.isDisabled = false;
        this.wpInlineCreate.newInlineWorkPackageReferenced.next(newRelationId);
        this.cancel();
      })
      .catch((err:any) => {
        this.notificationService.handleRawError(err, this.workPackage);
        this.isDisabled = false;
        this.cancel();
      });
  }

  public onSelected(workPackage?:WorkPackageResource) {
    if (workPackage) {
      this.selectedWpId = workPackage.id!;
      this.addExisting();
    }
  }

  public get relationType() {
    return this.wpInlineCreate.relationType;
  }

  public get workPackage() {
    return this.wpInlineCreate.referenceTarget!;
  }

  public cancel() {
    this.parent.resetRow();
  }

  private buildQueryFilters():ApiV3Filter[] {
    const query = this.querySpace.query.value;

    if (!query) {
      return [];
    }

    const relationTypes = RelationResource.RELATION_TYPES(true);
    const filters = query.filters.filter((filter) => {
      const id = this.urlParamsHelper.buildV3GetFilterIdFromFilter(filter);
      return relationTypes.indexOf(id) === -1;
    });

    return this.urlParamsHelper.buildV3GetFilters(filters);
  }
}
