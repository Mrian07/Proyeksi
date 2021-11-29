

import {
  ChangeDetectionStrategy,
  ChangeDetectorRef,
  Component,
  ElementRef,
  Injector,
  OnInit,
  ViewChild,
} from '@angular/core';
import { AbstractWidgetComponent } from 'core-app/shared/components/grids/widgets/abstract-widget.component';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';
import { ProjectResource } from 'core-app/features/hal/resources/project-resource';
import { WorkPackageViewHighlightingService } from 'core-app/features/work-packages/routing/wp-view-base/view-services/wp-view-highlighting.service';
import { IsolatedQuerySpace } from 'core-app/features/work-packages/directives/query-space/isolated-query-space';
import { Observable } from 'rxjs';
import { HalResourceEditingService } from 'core-app/shared/components/fields/edit/services/hal-resource-editing.service';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

@Component({
  templateUrl: './project-status.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  providers: [
    WorkPackageViewHighlightingService,
    IsolatedQuerySpace,
    HalResourceEditingService,
  ],
})
export class WidgetProjectStatusComponent extends AbstractWidgetComponent implements OnInit {
  @ViewChild('contentContainer', { static: true }) readonly contentContainer:ElementRef;

  public currentStatusCode = 'not set';

  public explanation = '';

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
