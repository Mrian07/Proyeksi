

import { AbstractWorkPackageButtonComponent } from 'core-app/features/work-packages/components/wp-buttons/wp-buttons.module';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, OnInit,
} from '@angular/core';
import { WorkPackageViewFiltersService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-filters.service';
import { componentDestroyed } from '@w11k/ngx-componentdestroyed';
import { WorkPackageFiltersService } from 'core-app/features/work-packages/components/filters/wp-filters/wp-filters.service';

@Component({
  selector: 'wp-filter-button',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './wp-filter-button.html',
})
export class WorkPackageFilterButtonComponent extends AbstractWorkPackageButtonComponent implements OnInit {
  public count:number;

  public initialized = false;

  public buttonId = 'work-packages-filter-toggle-button';

  public iconClass = 'icon-filter';

  constructor(readonly I18n:I18nService,
    protected cdRef:ChangeDetectorRef,
    protected wpFiltersService:WorkPackageFiltersService,
    protected wpTableFilters:WorkPackageViewFiltersService) {
    super(I18n);
  }

  ngOnInit():void {
    this.setupObserver();
  }

  public get labelKey():string {
    return 'js.button_filter';
  }

  public get textKey():string {
    return 'js.toolbar.filter';
  }

  public get label():string {
    return this.prefix + this.text.label;
  }

  public get filterCount():number {
    return this.count;
  }

  public performAction(event:Event) {
    this.toggleVisibility();
  }

  public toggleVisibility() {
    this.wpFiltersService.toggleVisibility();
  }

  private setupObserver() {
    this.wpTableFilters
      .live$()
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe(() => {
        this.count = this.wpTableFilters.currentlyVisibleFilters.length;
        this.initialized = true;
        this.cdRef.detectChanges();
      });

    this.wpFiltersService
      .observeUntil(componentDestroyed(this))
      .subscribe(() => {
        this.isActive = this.wpFiltersService.visible;
        this.cdRef.detectChanges();
      });
  }
}
