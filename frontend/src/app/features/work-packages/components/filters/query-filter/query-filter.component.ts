

import {
  Component, EventEmitter, Input, OnInit, Output,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { halHref, compareByHref } from 'core-app/shared/helpers/angular/tracking-functions';
import { BannersService } from 'core-app/core/enterprise/banners.service';
import { WorkPackageViewFiltersService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-filters.service';
import { SchemaCacheService } from 'core-app/core/schemas/schema-cache.service';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';
import { QueryFilterInstanceResource } from 'core-app/features/hal/resources/query-filter-instance-resource';
import { QueryFilterResource } from 'core-app/features/hal/resources/query-filter-resource';

@Component({
  selector: '[query-filter]',
  templateUrl: './query-filter.component.html',
})
export class QueryFilterComponent implements OnInit {
  @Input() public shouldFocus = false;

  @Input() public filter:QueryFilterInstanceResource;

  @Output() public filterChanged = new EventEmitter<QueryFilterResource>();

  @Output() public deactivateFilter = new EventEmitter<QueryFilterResource>();

  public availableOperators:any;

  public showValuesInput = false;

  public eeShowBanners = false;

  public trackByHref = halHref;

  public compareByHref = compareByHref;

  public text = {
    open_filter: this.I18n.t('js.filter.description.text_open_filter'),
    close_filter: this.I18n.t('js.filter.description.text_close_filter'),
    label_filter_add: this.I18n.t('js.work_packages.label_filter_add'),
    upsale_for_more: this.I18n.t('js.filter.upsale_for_more'),
    upsale_link: this.I18n.t('js.filter.upsale_link'),
    button_delete: this.I18n.t('js.button_delete'),
  };

  constructor(readonly wpTableFilters:WorkPackageViewFiltersService,
    readonly schemaCache:SchemaCacheService,
    readonly I18n:I18nService,
    readonly currentProject:CurrentProjectService,
    readonly bannerService:BannersService) {
  }

  public onFilterUpdated(filter:QueryFilterInstanceResource) {
    this.filter = filter;
    this.showValuesInput = this.showValues();
    this.filterChanged.emit();
  }

  public removeThisFilter() {
    this.deactivateFilter.emit(this.filter);
  }

  public get valueType():string|undefined {
    if (this.filter.currentSchema && this.filter.currentSchema.values) {
      return this.filter.currentSchema.values.type;
    }

    return undefined;
  }

  ngOnInit() {
    this.eeShowBanners = this.bannerService.eeShowBanners;
    this.availableOperators = this.schemaCache.of(this.filter).availableOperators;
    this.showValuesInput = this.showValues();
  }

  private showValues() {
    return this.filter.currentSchema!.isValueRequired() && this.filter.currentSchema!.values!.type !== '[1]Boolean';
  }
}
