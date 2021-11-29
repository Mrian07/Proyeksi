

import { NgModule } from '@angular/core';
import { OpenprojectWorkPackagesModule } from 'core-app/features/work-packages/openproject-work-packages.module';
import { GlobalSearchInputComponent } from 'core-app/core/global_search/input/global-search-input.component';
import { GlobalSearchWorkPackagesComponent } from 'core-app/core/global_search/global-search-work-packages.component';
import { GlobalSearchTabsComponent } from 'core-app/core/global_search/tabs/global-search-tabs.component';
import { GlobalSearchTitleComponent } from 'core-app/core/global_search/title/global-search-title.component';
import { GlobalSearchService } from 'core-app/core/global_search/services/global-search.service';
import { GlobalSearchWorkPackagesEntryComponent } from 'core-app/core/global_search/global-search-work-packages-entry.component';
import { OpenprojectAutocompleterModule } from 'core-app/shared/components/autocompleter/openproject-autocompleter.module';
import { OPSharedModule } from 'core-app/shared/shared.module';

@NgModule({
  imports: [
    OPSharedModule,
    OpenprojectWorkPackagesModule,
    OpenprojectAutocompleterModule,
  ],
  providers: [
    GlobalSearchService,
  ],
  declarations: [
    GlobalSearchInputComponent,
    GlobalSearchWorkPackagesEntryComponent,
    GlobalSearchWorkPackagesComponent,
    GlobalSearchTabsComponent,
    GlobalSearchTitleComponent,
  ],
})
export class OpenprojectGlobalSearchModule { }
