

import {
  AfterViewInit, ChangeDetectorRef, Component, EventEmitter, Injector, Output,
} from '@angular/core';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';
import { CreateAutocompleterComponent } from 'core-app/shared/components/autocompleter/create-autocompleter/create-autocompleter.component';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { VersionResource } from 'core-app/features/hal/resources/version-resource';
import { HalResourceNotificationService } from 'core-app/features/hal/services/hal-resource-notification.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';

@Component({
  templateUrl: '../create-autocompleter/create-autocompleter.component.html',
  selector: 'version-autocompleter',
})
export class VersionAutocompleterComponent extends CreateAutocompleterComponent implements AfterViewInit {
  @Output() public onCreate = new EventEmitter<VersionResource>();

  constructor(
    readonly injector:Injector,
    readonly I18n:I18nService,
    readonly currentProject:CurrentProjectService,
    readonly cdRef:ChangeDetectorRef,
    readonly pathHelper:PathHelperService,
    readonly apiV3Service:APIV3Service,
    readonly halNotification:HalResourceNotificationService,
  ) {
    super(injector);
  }

  ngAfterViewInit() {
    super.ngAfterViewInit();

    this.canCreateNewActionElements().then((val) => {
      if (val) {
        this.createAllowed = (input:string) => this.createNewVersion(input);
        this.cdRef.detectChanges();
      }
    });
  }

  /**
   * Checks for correct permissions
   * (whether the current project is in the list of allowed values in the version create form)
   * @returns {Promise<boolean>}
   */
  public canCreateNewActionElements():Promise<boolean> {
    if (!this.currentProject.id) {
      return Promise.resolve(false);
    }

    return this
      .apiV3Service
      .versions
      .available_projects
      .exists(this.currentProject.id)
      .toPromise()
      .catch(() => false);
  }

  protected createNewVersion(name:string) {
    this
      .apiV3Service
      .versions
      .post(this.getVersionPayload(name))
      .subscribe(
        (version) => this.onCreate.emit(version),
        (error) => {
          this.closeSelect();
          this.halNotification.handleRawError(error);
        },
      );
  }

  private getVersionPayload(name:string) {
    const payload:any = {};
    payload.name = name;
    payload._links = {
      definingProject: {
        href: this.apiV3Service.projects.id(this.currentProject.id!).path,
      },
    };

    return payload;
  }
}
