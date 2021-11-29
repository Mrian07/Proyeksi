
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { UIRouterModule } from '@uirouter/angular';
import { FocusModule } from 'core-app/shared/directives/focus/focus.module';
import { AttributeHelpTextModule } from 'core-app/shared/components/attribute-help-texts/attribute-help-text.module';
import { ContentTabsComponent } from 'core-app/shared/components/tabs/content-tabs/content-tabs.component';
import { ScrollableTabsComponent } from 'core-app/shared/components/tabs/scrollable-tabs/scrollable-tabs.component';
import { TabCountComponent } from 'core-app/shared/components/tabs/tab-badges/tab-count.component';
import { IconModule } from 'core-app/shared/components/icon/icon.module';

@NgModule({
  imports: [
    CommonModule,
    FocusModule,
    IconModule,
    AttributeHelpTextModule,
    UIRouterModule,
  ],
  exports: [
    ScrollableTabsComponent,
  ],
  declarations: [
    ScrollableTabsComponent,
    ContentTabsComponent,
    TabCountComponent,
  ],
})
export class OpenprojectTabsModule {
}
