

import { UIRouterGlobals } from '@uirouter/core';
import {
  Component,
  OnInit,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { WpTabDefinition } from 'core-app/features/work-packages/components/wp-tabs/components/wp-tab-wrapper/tab';
import { WorkPackageTabsService } from 'core-app/features/work-packages/components/wp-tabs/services/wp-tabs/wp-tabs.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';

@Component({
  templateUrl: './wp-tab-wrapper.html',
  selector: 'op-wp-tab',
})
export class WpTabWrapperComponent implements OnInit {
  workPackage:WorkPackageResource;

  ndcDynamicInputs$:Observable<{
    workPackage:WorkPackageResource;
    tab:WpTabDefinition | undefined;
  }>;

  get workPackageId():string {
    const { workPackageId } = this.uiRouterGlobals.params as unknown as { workPackageId:string };
    return workPackageId;
  }

  constructor(readonly I18n:I18nService,
    readonly uiRouterGlobals:UIRouterGlobals,
    readonly apiV3Service:APIV3Service,
    readonly wpTabsService:WorkPackageTabsService) {}

  ngOnInit() {
    this.ndcDynamicInputs$ = this
      .apiV3Service
      .work_packages
      .id(this.workPackageId)
      .requireAndStream()
      .pipe(
        map((wp) => ({
          workPackage: wp,
          tab: this.findTab(wp),
        })),
      );
  }

  findTab(workPackage:WorkPackageResource):WpTabDefinition | undefined {
    const { tabIdentifier } = this.uiRouterGlobals.params as unknown as { tabIdentifier:string };

    return this.wpTabsService.getTab(tabIdentifier, workPackage);
  }
}
