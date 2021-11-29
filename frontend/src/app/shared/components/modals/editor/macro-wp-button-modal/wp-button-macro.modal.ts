

import {
  AfterViewInit, ChangeDetectorRef, Component, ElementRef, Inject, ViewChild,
} from '@angular/core';
import { OpModalLocalsMap } from 'core-app/shared/components/modal/modal.types';
import { OpModalComponent } from 'core-app/shared/components/modal/modal.component';
import { OpModalLocalsToken } from 'core-app/shared/components/modal/modal.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { TypeResource } from 'core-app/features/hal/resources/type-resource';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';
import { APIV3Service } from 'core-app/core/apiv3/api-v3.service';
import { FormResource } from 'core-app/features/hal/resources/form-resource';

@Component({
  templateUrl: './wp-button-macro.modal.html',
})
export class WpButtonMacroModalComponent extends OpModalComponent implements AfterViewInit {
  public changed = false;

  public showClose = true;

  public closeOnEscape = true;

  public closeOnOutsideClick = true;

  public selectedType:string;

  public buttonStyle:boolean;

  public availableTypes:TypeResource[];

  public type = '';

  public classes = '';

  @ViewChild('typeSelect', { static: true }) typeSelect:ElementRef;

  public text:any = {
    title: this.I18n.t('js.editor.macro.work_package_button.button'),
    none: this.I18n.t('js.label_none'),
    selected_type: this.I18n.t('js.editor.macro.work_package_button.type'),
    button_style: this.I18n.t('js.editor.macro.work_package_button.button_style'),
    button_style_hint: this.I18n.t('js.editor.macro.work_package_button.button_style_hint'),
    button_save: this.I18n.t('js.button_save'),
    button_cancel: this.I18n.t('js.button_cancel'),
    close_popup: this.I18n.t('js.close_popup_title'),
  };

  constructor(readonly elementRef:ElementRef,
    @Inject(OpModalLocalsToken) public locals:OpModalLocalsMap,
    protected currentProject:CurrentProjectService,
    protected apiV3Service:APIV3Service,
    readonly cdRef:ChangeDetectorRef,
    readonly I18n:I18nService) {
    super(locals, cdRef, elementRef);
    this.selectedType = this.type = this.locals.type;
    this.classes = this.locals.classes;
    this.buttonStyle = this.classes === 'button';

    this
      .apiV3Service
      .withOptionalProject(this.currentProject.identifier)
      .work_packages
      .form
      .post({})
      .subscribe((form:FormResource) => {
        this.availableTypes = form.schema.type.allowedValues;
      });
  }

  public applyAndClose(evt:JQuery.TriggeredEvent) {
    this.changed = true;
    this.classes = this.buttonStyle ? 'button' : '';
    this.type = this.selectedType;
    this.closeMe(evt);
  }

  ngAfterViewInit() {
    this.typeSelect.nativeElement.focus();
  }
}
