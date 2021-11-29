    

import {
  ChangeDetectionStrategy,
  ChangeDetectorRef,
  Component,
  ElementRef,
  HostBinding,
  Injector,
} from '@angular/core';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { SchemaCacheService } from 'core-app/core/schemas/schema-cache.service';
import { HalResourceEditingService } from 'core-app/shared/components/fields/edit/services/hal-resource-editing.service';
import { DisplayFieldService } from 'core-app/shared/components/fields/display/display-field.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { CombinedDateDisplayField } from 'core-app/shared/components/fields/display/field-types/combined-date-display.field';
import { PathHelperService } from 'core-app/core/path-helper/path-helper.service';

export const quickInfoMacroSelector = 'macro.macro--wp-quickinfo';

@Component({
  selector: quickInfoMacroSelector,
  templateUrl: './work-package-quickinfo-macro.html',
  styleUrls: ['./work-package-quickinfo-macro.sass'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  providers: [
    HalResourceEditingService,
  ],
})
export class WorkPackageQuickinfoMacroComponent {
  // Whether the value could not be loaded
  error:string|null = null;

  text = {
    not_found: this.I18n.t('js.editor.macro.attribute_reference.not_found'),
    help: this.I18n.t('js.editor.macro.attribute_reference.macro_help_tooltip'),
  };

  @HostBinding('title') hostTitle = this.text.help;

  /** Work package to be shown */
  workPackage$:Observable<WorkPackageResource>;

  dateDisplayField = CombinedDateDisplayField;

  workPackageLink:string;

  detailed = false;

  constructor(readonly elementRef:ElementRef,
    readonly injector:Injector,
    readonly apiV3Service:APIV3Service,
    readonly schemaCache:SchemaCacheService,
    readonly displayField:DisplayFieldService,
    readonly pathHelper:PathHelperService,
    readonly I18n:I18nService,
    readonly cdRef:ChangeDetectorRef) {

  }

  ngOnInit() {
    const element = this.elementRef.nativeElement as HTMLElement;
    const id:string = element.dataset.id!;
    this.detailed = element.dataset.detailed === 'true';
    this.workPackageLink = this.pathHelper.workPackagePath(id);

    this.workPackage$ = this
      .apiV3Service
      .work_packages
      .id(id)
      .get()
      .pipe(
        tap({ error: (e) => this.markError(this.text.not_found) }),
      );
  }

  markError(message:string) {
    console.error(`Failed to render macro ${message}`);
    this.error = this.I18n.t('js.editor.macro.error', { message });
    this.cdRef.detectChanges();
  }
}
