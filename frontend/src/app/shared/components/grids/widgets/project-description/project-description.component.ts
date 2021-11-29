

import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, Injector, OnInit,
} from '@angular/core';
import { AbstractWidgetComponent } from 'core-app/shared/components/grids/widgets/abstract-widget.component';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';
import { Observable } from 'rxjs';
import { ProjectResource } from 'core-app/features/hal/resources/project-resource';
import { HalResourceEditingService } from 'core-app/shared/components/fields/edit/services/hal-resource-editing.service';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

@Component({
  templateUrl: './project-description.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  providers: [
    HalResourceEditingService,
  ],
})
export class WidgetProjectDescriptionComponent extends AbstractWidgetComponent implements OnInit {
  public project$:Observable<ProjectResource>;

  constructor(protected readonly i18n:I18nService,
    protected readonly injector:Injector,
    protected readonly apiV3Service:APIV3Service,
    protected readonly currentProject:CurrentProjectService,
    protected readonly cdRef:ChangeDetectorRef) {
    super(i18n, injector);
  }

  ngOnInit() {
    this.project$ = this
      .apiV3Service
      .projects
      .id(this.currentProject.id!)
      .get();

    this.cdRef.detectChanges();
  }

  public get isEditable() {
    return false;
  }
}
