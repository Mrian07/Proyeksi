

import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { HalResourceEditingService } from 'core-app/shared/components/fields/edit/services/hal-resource-editing.service';
import {
  ChangeDetectorRef, Component, Input, OnInit,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { Highlighting } from 'core-app/features/work-packages/components/wp-fast-table/builders/highlighting/highlighting.functions';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { SchemaCacheService } from 'core-app/core/schemas/schema-cache.service';

@Component({
  selector: 'wp-status-button',
  styleUrls: ['./wp-status-button.component.sass'],
  templateUrl: './wp-status-button.html',
})
export class WorkPackageStatusButtonComponent extends UntilDestroyedMixin implements OnInit {
  @Input('workPackage') public workPackage:WorkPackageResource;

  public text = {
    explanation: this.I18n.t('js.label_edit_status'),
    workPackageReadOnly: this.I18n.t('js.work_packages.message_work_package_read_only'),
    workPackageStatusBlocked: this.I18n.t('js.work_packages.message_work_package_status_blocked'),
  };

  constructor(readonly I18n:I18nService,
    readonly cdRef:ChangeDetectorRef,
    readonly schemaCache:SchemaCacheService,
    readonly halEditing:HalResourceEditingService) {
    super();
  }

  ngOnInit() {
    this.halEditing
      .temporaryEditResource(this.workPackage)
      .values$()
      .pipe(
        this.untilDestroyed(),
      )
      .subscribe((wp) => {
        this.workPackage = wp;

        if (this.workPackage.status) {
          this.workPackage.status.$load();
        }

        this.cdRef.detectChanges();
      });
  }

  public get buttonTitle() {
    if (this.schema.isReadonly) {
      return this.text.workPackageReadOnly;
    } if (this.schema.isEditable && !this.allowed) {
      return this.text.workPackageStatusBlocked;
    }
    return '';
  }

  public get statusHighlightClass() {
    const { status } = this;
    if (!status) {
      return;
    }
    return Highlighting.backgroundClass('status', status.id!);
  }

  public get status():HalResource {
    return this.workPackage.status;
  }

  public get isReadonly() {
    return this.schema.isReadonly;
  }

  public get allowed() {
    return this.schema.isAttributeEditable('status');
  }

  private get schema() {
    if (this.halEditing.typedState(this.workPackage).hasValue()) {
      return this.halEditing.typedState(this.workPackage).value!.schema;
    }
    return this.schemaCache.of(this.workPackage);
  }
}
