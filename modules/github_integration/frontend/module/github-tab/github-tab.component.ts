import { Component, Input } from '@angular/core';
import { WorkPackageResource } from "core-app/features/hal/resources/work-package-resource";
import { TabComponent } from "core-app/features/work-packages/components/wp-tabs/components/wp-tab-wrapper/tab";
import { I18nService } from "core-app/core/i18n/i18n.service";
import { PathHelperService } from "core-app/core/path-helper/path-helper.service";

@Component({
  selector: 'github-tab',
  templateUrl: './github-tab.template.html'
})
export class GitHubTabComponent implements TabComponent {
  @Input() public workPackage:WorkPackageResource;

  constructor(readonly PathHelper:PathHelperService,
              readonly I18n:I18nService) {
  }
}
