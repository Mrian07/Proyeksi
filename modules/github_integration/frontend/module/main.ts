

import { Injector, NgModule } from '@angular/core';
import { OPSharedModule } from 'core-app/shared/shared.module';
import { OpenprojectTabsModule } from 'core-app/shared/components/tabs/openproject-tabs.module';
import { WorkPackageTabsService } from 'core-app/features/work-packages/components/wp-tabs/services/wp-tabs/wp-tabs.service';
import { GitHubTabComponent } from './github-tab/github-tab.component';
import { TabHeaderComponent } from './tab-header/tab-header.component';
import { TabPrsComponent } from './tab-prs/tab-prs.component';
import { GitActionsMenuDirective } from './git-actions-menu/git-actions-menu.directive';
import { GitActionsMenuComponent } from './git-actions-menu/git-actions-menu.component';
import { WorkPackagesGithubPrsService } from './tab-prs/wp-github-prs.service';
import { PullRequestComponent } from './pull-request/pull-request.component';

export function initializeGithubIntegrationPlugin(injector:Injector) {
  const wpTabService = injector.get(WorkPackageTabsService);
  wpTabService.register({
    component: GitHubTabComponent,
    name: I18n.t('js.github_integration.work_packages.tab_name'),
    id: 'github',
    displayable: (workPackage) => !!workPackage.github,
  });
}

@NgModule({
  imports: [
    OPSharedModule,
    OpenprojectTabsModule,
  ],
  providers: [
    WorkPackagesGithubPrsService,
  ],
  declarations: [
    GitHubTabComponent,
    TabHeaderComponent,
    TabPrsComponent,
    GitActionsMenuDirective,
    GitActionsMenuComponent,
    PullRequestComponent,
  ],
  exports: [
    GitHubTabComponent,
    TabHeaderComponent,
    TabPrsComponent,
    GitActionsMenuDirective,
    GitActionsMenuComponent,
  ],
})
export class PluginModule {
  constructor(injector:Injector) {
    initializeGithubIntegrationPlugin(injector);
  }
}
