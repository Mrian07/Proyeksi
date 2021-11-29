

import { QueryColumn } from 'core-app/features/work-packages/components/wp-query/query-column';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { HighlightingMode } from 'core-app/features/work-packages/components/wp-fast-table/builders/highlighting/highlighting-mode.const';
import { QueryOrder } from 'core-app/core/apiv3/endpoints/queries/apiv3-query-order';
import { WorkPackageCollectionResource } from 'core-app/features/hal/resources/wp-collection-resource';
import { QueryFilterInstanceResource } from 'core-app/features/hal/resources/query-filter-instance-resource';
import { ProjectResource } from 'core-app/features/hal/resources/project-resource';
import { QuerySortByResource } from 'core-app/features/hal/resources/query-sort-by-resource';
import { QueryGroupByResource } from 'core-app/features/hal/resources/query-group-by-resource';

export interface QueryResourceEmbedded {
  results:WorkPackageCollectionResource;
  columns:QueryColumn[];
  groupBy:QueryGroupByResource|undefined;
  project:ProjectResource;
  sortBy:QuerySortByResource[];
  filters:QueryFilterInstanceResource[];
}

export type TimelineZoomLevel = 'days'|'weeks'|'months'|'quarters'|'years'|'auto';

export interface TimelineLabels {
  left:string|null;
  right:string|null;
  farRight:string|null;
}

export class QueryResource extends HalResource {
  public $embedded:QueryResourceEmbedded;

  public results:WorkPackageCollectionResource;

  public columns:QueryColumn[];

  public groupBy:QueryGroupByResource|undefined;

  public sortBy:QuerySortByResource[];

  public filters:QueryFilterInstanceResource[];

  public starred:boolean;

  public sums:boolean;

  public hasError:boolean;

  public timelineVisible:boolean;

  public timelineZoomLevel:TimelineZoomLevel;

  public highlightingMode:HighlightingMode;

  public highlightedAttributes:HalResource[]|undefined;

  public displayRepresentation:string|undefined;

  public timelineLabels:TimelineLabels;

  public showHierarchies:boolean;

  public public:boolean;

  public hidden:boolean;

  public project:ProjectResource;

  public ordered_work_packages:QueryOrder;

  public $initialize(source:any) {
    super.$initialize(source);

    this.filters = this
      .filters
      .map((filter:unknown) => new QueryFilterInstanceResource(
        this.injector,
        filter,
        true,
        this.halInitializer,
        'QueryFilterInstance',
      ));
  }
}

export interface QueryResourceLinks {
  updateImmediately?(attributes:any):Promise<any>;
}

export interface QueryResource extends QueryResourceLinks {}
