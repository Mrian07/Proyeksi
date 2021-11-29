

import {
  ChangeDetectorRef,
  Component,
  OnDestroy,
  Injector,
} from '@angular/core';
import { Subscription } from 'rxjs';
import { GlobalSearchService } from 'core-app/core/global_search/services/global-search.service';
import { ScrollableTabsComponent } from 'core-app/shared/components/tabs/scrollable-tabs/scrollable-tabs.component';
import { TabDefinition } from 'core-app/shared/components/tabs/tab.interface';

export const globalSearchTabsSelector = 'global-search-tabs';

@Component({
  selector: globalSearchTabsSelector,
  templateUrl: '../../../shared/components/tabs/scrollable-tabs/scrollable-tabs.component.html',
})

export class GlobalSearchTabsComponent extends ScrollableTabsComponent implements OnDestroy {
  private currentTabSub:Subscription;

  private tabsSub:Subscription;

  public classes:string[] = ['global-search--tabs', 'scrollable-tabs'];

  constructor(
    readonly globalSearchService:GlobalSearchService,
    public injector:Injector,
    cdRef:ChangeDetectorRef,
  ) {
    super(cdRef, injector);
  }

  ngOnInit() {
    this.currentTabSub = this.globalSearchService
      .currentTab$
      .subscribe((currentTab) => {
        this.currentTabId = currentTab;
      });

    this.tabsSub = this.globalSearchService
      .tabs$
      .subscribe((tabs) => {
        this.tabs = tabs;
        this.tabs.map((tab) => (tab.path = '#'));
      });
  }

  public clickTab(tab:TabDefinition, event:Event) {
    super.clickTab(tab, event);

    this.globalSearchService.currentTab = tab.id;
    this.globalSearchService.submitSearch();
  }

  ngOnDestroy():void {
    this.currentTabSub.unsubscribe();
    this.tabsSub.unsubscribe();
  }
}
