

import { Injector, NgModule } from '@angular/core';
import { OPSharedModule } from 'core-app/shared/shared.module';
import { NgxGalleryModule } from '@kolkov/ngx-gallery';
import { DisplayFieldService } from 'core-app/shared/components/fields/display/display-field.service';
import { BcfThumbnailDisplayField } from 'core-app/features/bim/bcf/fields/display/bcf-thumbnail-field.module';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { BcfDetectorService } from 'core-app/features/bim/bcf/helper/bcf-detector.service';
import { BcfPathHelperService } from 'core-app/features/bim/bcf/helper/bcf-path-helper.service';
import { ViewpointsService } from 'core-app/features/bim/bcf/helper/viewpoints.service';
import { BcfImportButtonComponent } from 'core-app/features/bim/ifc_models/toolbar/import-export-bcf/bcf-import-button.component';
import { BcfExportButtonComponent } from 'core-app/features/bim/ifc_models/toolbar/import-export-bcf/bcf-export-button.component';
import { IFCViewerService } from 'core-app/features/bim/ifc_models/ifc-viewer/ifc-viewer.service';
import { ViewerBridgeService } from 'core-app/features/bim/bcf/bcf-viewer-bridge/viewer-bridge.service';
import { HookService } from 'core-app/features/plugins/hook-service';
import { BcfWpAttributeGroupComponent } from 'core-app/features/bim/bcf/bcf-wp-attribute-group/bcf-wp-attribute-group.component';
import { BcfNewWpAttributeGroupComponent } from 'core-app/features/bim/bcf/bcf-wp-attribute-group/bcf-new-wp-attribute-group.component';
import { RevitBridgeService } from 'core-app/features/bim/revit_add_in/revit-bridge.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { ProyeksiAppHeaderInterceptor } from 'core-app/features/hal/http/openproject-header-interceptor';
import isNewResource from 'core-app/features/hal/helpers/is-new-resource';
import { RefreshButtonComponent } from 'core-app/features/bim/ifc_models/toolbar/import-export-bcf/refresh-button.component';

/**
 * Determines based on the current user agent whether
 * we're running in Revit or not.
 *
 * Depending on that, we use the IFC viewer service for showing/saving viewpoints.
 */
export const viewerBridgeServiceFactory = (injector:Injector) => {
  if (window.navigator.userAgent.search('Revit') > -1) {
    return new RevitBridgeService(injector);
  }
  return injector.get(IFCViewerService, new IFCViewerService(injector));
};

@NgModule({
  imports: [
    OPSharedModule,
    NgxGalleryModule,
  ],
  providers: [
    { provide: HTTP_INTERCEPTORS, useClass: ProyeksiAppHeaderInterceptor, multi: true },
    {
      provide: ViewerBridgeService,
      useFactory: viewerBridgeServiceFactory,
      deps: [Injector],
    },
    BcfDetectorService,
    BcfPathHelperService,
    ViewpointsService,
  ],
  declarations: [
    BcfWpAttributeGroupComponent,
    BcfNewWpAttributeGroupComponent,
    BcfImportButtonComponent,
    BcfExportButtonComponent,
    RefreshButtonComponent,
  ],
  exports: [
    BcfImportButtonComponent,
    BcfExportButtonComponent,
    RefreshButtonComponent,
  ],
})
export class OpenprojectBcfModule {
  static bootstrapCalled = false;

  constructor(injector:Injector) {
    OpenprojectBcfModule.bootstrap(injector);
  }

  // The static property prevents running the function
  // multiple times. This happens e.g. when the module is included
  // into a plugin's module.
  public static bootstrap(injector:Injector):void {
    if (this.bootstrapCalled) {
      return;
    }

    this.bootstrapCalled = true;

    const displayFieldService = injector.get(DisplayFieldService);
    displayFieldService
      .addFieldType(BcfThumbnailDisplayField, 'bcfThumbnail', [
        'BCF Thumbnail',
      ]);

    const hookService = injector.get(HookService);
    hookService.register('prependedAttributeGroups', (workPackage:WorkPackageResource) => {
      if (!window.ProyeksiApp.isBimEdition) {
        return;
      }

      if (isNewResource(workPackage)) {
        return BcfNewWpAttributeGroupComponent;
      }
      return BcfWpAttributeGroupComponent;
    });
  }
}
