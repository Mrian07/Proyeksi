

import {
  ChangeDetectionStrategy,
  ChangeDetectorRef,
  Component,
  ElementRef,
  Injector,
} from '@angular/core';
import { GonService } from 'core-app/core/gon/gon.service';
import { StateService } from '@uirouter/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { ScrollableTabsComponent } from 'core-app/shared/components/tabs/scrollable-tabs/scrollable-tabs.component';
import { TabDefinition } from 'core-app/shared/components/tabs/tab.interface';

export const contentTabsSelector = 'content-tabs';

interface GonTab extends TabDefinition {
  partial:string;
  label:string;
}

@Component({
  selector: 'op-content-tabs',
  templateUrl: '../scrollable-tabs/scrollable-tabs.component.html',
  styleUrls: ['./content-tabs.component.sass'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})

export class ContentTabsComponent extends ScrollableTabsComponent {
  public classes:string[] = ['content--tabs', 'scrollable-tabs'];

  constructor(
    readonly elementRef:ElementRef,
    readonly $state:StateService,
    readonly gon:GonService,
    cdRef:ChangeDetectorRef,
    readonly I18n:I18nService,
    public injector:Injector,
  ) {
    super(cdRef, injector);

    const gonTabs = JSON.parse((this.gon.get('contentTabs') as any).tabs);
    const currentTab = JSON.parse((this.gon.get('contentTabs') as any).selected);

    // parse tabs from backend and map them to scrollable tabs structure
    this.tabs = gonTabs.map((tab:GonTab) => ({
      id: tab.name,
      name: this.I18n.t(`js.${tab.label}`, { defaultValue: tab.label }),
      path: tab.path,
    }));

    // highlight current tab
    this.currentTabId = currentTab.name;
  }
}
