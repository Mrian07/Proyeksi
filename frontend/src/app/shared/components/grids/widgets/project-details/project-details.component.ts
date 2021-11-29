

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
import { SchemaResource } from 'core-app/features/hal/resources/schema-resource';
import { Observable } from 'rxjs';
import { ProjectResource } from 'core-app/features/hal/resources/project-resource';
import { HalResourceEditingService } from 'core-app/shared/components/fields/edit/services/hal-resource-editing.service';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';

@Component({
  templateUrl: './project-details.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  providers: [
    HalResourceEditingService,
  ],
})
export class WidgetProjectDetailsComponent extends AbstractWidgetComponent implements OnInit {
  @ViewChild('contentContainer', { static: true }) readonly contentContainer:ElementRef;

  public customFields:{ key:string, label:string }[] = [];

  public project$:Observable<ProjectResource>;

  constructor(protected readonly i18n:I18nService,
    protected readonly injector:Injector,
    protected readonly apiV3Service:APIV3Service,
    protected readonly currentProject:CurrentProjectService,
    protected readonly cdRef:ChangeDetectorRef) {
    super(i18n, injector);
  }

  ngOnInit() {
    this.loadAndRender();
    this.project$ = this
      .apiV3Service
      .projects
      .id(this.currentProject.id!)
      .requireAndStream();
  }

  public get isEditable() {
    return false;
  }

  private loadAndRender() {
    Promise.all([
      this.loadProjectSchema(),
    ])
      .then(([schema]) => {
        this.setCustomFields(schema);
      });
  }

  private loadProjectSchema() {
    return this
      .apiV3Service
      .projects
      .schema
      .get()
      .toPromise();
  }

  private setCustomFields(schema:SchemaResource) {
    Object.entries(schema).forEach(([key, keySchema]) => {
      if (/customField\d+/.exec(key)) {
        this.customFields.push({ key, label: keySchema.name });
      }
    });

    this.cdRef.detectChanges();
  }
}
