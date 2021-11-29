
import { NgModule } from '@angular/core';
import { OpenprojectWorkPackagesModule } from 'core-app/features/work-packages/openproject-work-packages.module';
import { UIRouterModule } from '@uirouter/angular';
import { OPSharedModule } from 'core-app/shared/shared.module';
import { IFC_ROUTES } from 'core-app/features/bim/ifc_models/openproject-ifc-models.routes';
import { IFCViewerPageComponent } from 'core-app/features/bim/ifc_models/pages/viewer/ifc-viewer-page.component';
import { EmptyComponent } from 'core-app/features/bim/ifc_models/empty/empty-component';
import { BimViewToggleButtonComponent } from 'core-app/features/bim/ifc_models/toolbar/view-toggle/bim-view-toggle-button.component';
import { BimViewToggleDropdownDirective } from 'core-app/features/bim/ifc_models/toolbar/view-toggle/bim-view-toggle-dropdown.directive';
import { BimManageIfcModelsButtonComponent } from 'core-app/features/bim/ifc_models/toolbar/manage-ifc-models-button/bim-manage-ifc-models-button.component';
import { IFCViewerService } from 'core-app/features/bim/ifc_models/ifc-viewer/ifc-viewer.service';
import { OpenprojectFieldsModule } from 'core-app/shared/components/fields/openproject-fields.module';
import { BCFNewSplitComponent } from 'core-app/features/bim/ifc_models/bcf/new-split/bcf-new-split.component';
import { BcfListContainerComponent } from 'core-app/features/bim/ifc_models/bcf/list-container/bcf-list-container.component';
import { BimViewService } from 'core-app/features/bim/ifc_models/pages/viewer/bim-view.service';
import { IfcModelsDataService } from 'core-app/features/bim/ifc_models/pages/viewer/ifc-models-data.service';
import { OpenprojectBcfModule } from 'core-app/features/bim/bcf/openproject-bcf.module';
import { OpenprojectHalModule } from 'core-app/features/hal/openproject-hal.module';
import { IFCViewerComponent } from './ifc-viewer/ifc-viewer.component';

@NgModule({
  imports: [
    OPSharedModule,
    OpenprojectFieldsModule,
    OpenprojectHalModule,
    OpenprojectBcfModule,
    OpenprojectWorkPackagesModule,
    UIRouterModule.forChild({
      states: IFC_ROUTES,
    }),
  ],
  providers: [
    IFCViewerService,
    BimViewService,
    IfcModelsDataService,
  ],
  declarations: [
    // Pages
    IFCViewerPageComponent,

    // Regions of pages
    EmptyComponent,
    BcfListContainerComponent,

    // Toolbar
    BimManageIfcModelsButtonComponent,
    BimViewToggleButtonComponent,
    BimViewToggleDropdownDirective,

    BCFNewSplitComponent,
    IFCViewerComponent,
  ],
})
export class OpenprojectIFCModelsModule {
}
