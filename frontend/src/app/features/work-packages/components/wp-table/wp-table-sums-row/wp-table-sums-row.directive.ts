

import {
  AfterViewInit, Directive, ElementRef, Injector, Input,
} from '@angular/core';
import { takeUntil } from 'rxjs/operators';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { States } from 'core-app/core/states/states.service';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { QueryColumn } from 'core-app/features/work-packages/components/wp-query/query-column';
import { WorkPackageViewColumnsService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-columns.service';
import { WorkPackageViewSumService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-sum.service';
import { combineLatest } from 'rxjs';
import { GroupSumsBuilder } from 'core-app/features/work-packages/components/wp-fast-table/builders/modes/grouped/group-sums-builder';
import { WorkPackageTable } from 'core-app/features/work-packages/components/wp-fast-table/wp-fast-table';
import { SchemaCacheService } from 'core-app/core/schemas/schema-cache.service';
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';
import { WorkPackageCollectionResource } from 'core-app/features/hal/resources/wp-collection-resource';

@Directive({
  selector: '[wpTableSumsRow]',
  host: {
    '[class.-hidden]': 'isHidden',
  },
})
export class WorkPackageTableSumsRowController implements AfterViewInit {
  @Input('wpTableSumsRow-table') workPackageTable:WorkPackageTable;

  public isHidden = true;

  private text:{ sum:string };

  private element:HTMLTableRowElement;

  private groupSumsBuilder:GroupSumsBuilder;

  constructor(readonly injector:Injector,
    readonly elementRef:ElementRef,
    readonly querySpace:IsolatedQuerySpace,
    readonly states:States,
    readonly schemaCache:SchemaCacheService,
    readonly wpTableColumns:WorkPackageViewColumnsService,
    readonly wpTableSums:WorkPackageViewSumService,
    readonly I18n:I18nService) {
    this.text = {
      sum: I18n.t('js.label_total_sum'),
    };
  }

  ngAfterViewInit():void {
    this.element = this.elementRef.nativeElement;

    combineLatest([
      this.wpTableColumns.live$(),
      this.wpTableSums.live$(),
      this.querySpace.results.values$(),
    ])
      .pipe(
        takeUntil(this.querySpace.stopAllSubscriptions),
      )
      .subscribe(([columns, sum, resource]) => {
        this.isHidden = !sum;
        if (sum && resource.sumsSchema) {
          this.schemaCache
            .ensureLoaded(resource.sumsSchema.href!)
            .then((schema:SchemaResource) => {
              this.refresh(columns, resource, schema);
            });
        } else {
          this.clear();
        }
      });
  }

  private clear() {
    this.element.innerHTML = '';
  }

  private refresh(columns:QueryColumn[], resource:WorkPackageCollectionResource, schema:SchemaResource) {
    this.clear();
    this.render(columns, resource, schema);
  }

  private render(columns:QueryColumn[], resource:WorkPackageCollectionResource, schema:SchemaResource) {
    this.groupSumsBuilder = new GroupSumsBuilder(this.injector, this.workPackageTable);
    this.groupSumsBuilder.text = this.text;
    this.groupSumsBuilder.renderColumns(resource.totalSums!, this.element);
  }
}
