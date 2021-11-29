

import { NgModule } from '@angular/core';
import { OPSharedModule } from 'core-app/shared/shared.module';
import { OpenprojectModalModule } from 'core-app/shared/components/modal/modal.module';
import { OpenprojectWorkPackagesModule } from 'core-app/features/work-packages/openproject-work-packages.module';
import { WpGraphConfigurationModalComponent } from 'core-app/shared/components/work-package-graphs/configuration-modal/wp-graph-configuration.modal';
import { WpGraphConfigurationFiltersTabComponent } from 'core-app/shared/components/work-package-graphs/configuration-modal/tabs/filters-tab.component';
import { WpGraphConfigurationSettingsTabComponent } from 'core-app/shared/components/work-package-graphs/configuration-modal/tabs/settings-tab.component';
import { WpGraphConfigurationFiltersTabInnerComponent } from 'core-app/shared/components/work-package-graphs/configuration-modal/tabs/filters-tab-inner.component';
import { WpGraphConfigurationSettingsTabInnerComponent } from 'core-app/shared/components/work-package-graphs/configuration-modal/tabs/settings-tab-inner.component';
import { WorkPackageEmbeddedGraphComponent } from 'core-app/shared/components/work-package-graphs/embedded/wp-embedded-graph.component';
import { WorkPackageOverviewGraphComponent } from 'core-app/shared/components/work-package-graphs/overview/wp-overview-graph.component';
import { ChartsModule } from 'ng2-charts';
import * as ChartDataLabels from 'chartjs-plugin-datalabels';
import { OpenprojectTabsModule } from 'core-app/shared/components/tabs/openproject-tabs.module';

@NgModule({
  imports: [
    // Commons
    OPSharedModule,
    OpenprojectModalModule,

    OpenprojectWorkPackagesModule,

    ChartsModule,
    OpenprojectTabsModule,
  ],
  declarations: [
    // Modals
    WpGraphConfigurationModalComponent,
    WpGraphConfigurationFiltersTabComponent,
    WpGraphConfigurationFiltersTabInnerComponent,
    WpGraphConfigurationSettingsTabComponent,
    WpGraphConfigurationSettingsTabInnerComponent,

    // Embedded graphs
    WorkPackageEmbeddedGraphComponent,
    // Work package graphs on version page
    WorkPackageOverviewGraphComponent,

  ],
  exports: [
    // Modals
    WpGraphConfigurationModalComponent,

    // Embedded graphs
    WorkPackageEmbeddedGraphComponent,
    WorkPackageOverviewGraphComponent,
  ],
})
export class OpenprojectWorkPackageGraphsModule {
  constructor() {
    // By this seemingly useless statement, the plugin is registered with Chart.
    // Simply importing it will have it removed probably by angular tree shaking
    // so it will not be active. The current default of the plugin is to be enabled
    // by default. This will be changed in the future:
    // https://github.com/chartjs/chartjs-plugin-datalabels/issues/42
    //
    // eslint-ignore-next-line @typescript-eslint/no-unused-expressions
    ChartDataLabels;
  }
}
