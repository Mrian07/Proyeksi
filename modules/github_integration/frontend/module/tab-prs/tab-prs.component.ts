

import { ChangeDetectorRef, Component, Input, OnInit } from '@angular/core';
import { WorkPackageResource } from "core-app/features/hal/resources/work-package-resource";
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { HalResourceService } from "core-app/features/hal/services/hal-resource.service";
import { CollectionResource } from "core-app/features/hal/resources/collection-resource";
import { IGithubPullRequestResource } from "../../../../../../../../modules/github_integration/frontend/module/typings";
import { I18nService } from "core-app/core/i18n/i18n.service";

@Component({
  selector: 'tab-prs',
  templateUrl: './tab-prs.template.html',
  host: { class: 'op-prs' }
})
export class TabPrsComponent implements OnInit {
  @Input() public workPackage:WorkPackageResource;

  public pullRequests:IGithubPullRequestResource[] = [];

  constructor(
    readonly I18n:I18nService,
    readonly apiV3Service:APIV3Service,
    readonly halResourceService:HalResourceService,
    readonly changeDetector:ChangeDetectorRef,
  ) {}

  ngOnInit(): void {
    const pullRequestsPath = this.apiV3Service.work_packages.id({id: this.workPackage.id })?.github_pull_requests.path;

    this.halResourceService
      .get<CollectionResource<IGithubPullRequestResource>>(pullRequestsPath)
      .subscribe((value) => {
        this.pullRequests = value.elements;
        this.changeDetector.detectChanges();
      });
  }

  public getEmptyText() {
    return this.I18n.t('js.github_integration.tab_prs.empty',{ wp_id: this.workPackage.id });
  }
}
