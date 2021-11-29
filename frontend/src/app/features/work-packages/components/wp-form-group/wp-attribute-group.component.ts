

import {
  Component, Injector, Input, AfterViewInit,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { EditFormComponent } from 'core-app/shared/components/fields/edit/edit-form/edit-form.component';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { fromEvent } from 'rxjs';
import { debounceTime } from 'rxjs/operators';
import {
  FieldDescriptor,
  GroupDescriptor,
} from 'core-app/features/work-packages/components/wp-single-view/wp-single-view.component';

@Component({
  selector: 'wp-attribute-group',
  templateUrl: './wp-attribute-group.template.html',
})
export class WorkPackageFormAttributeGroupComponent extends UntilDestroyedMixin implements AfterViewInit {
  @Input() public workPackage:WorkPackageResource;

  @Input() public group:GroupDescriptor;

  constructor(readonly I18n:I18nService,
    public wpEditForm:EditFormComponent,
    protected injector:Injector) {
    super();
  }

  ngAfterViewInit() {
    setTimeout(() => this.fixColumns());

    // Listen to resize event and fix column start again
    fromEvent(window, 'resize', { passive: true })
      .pipe(
        this.untilDestroyed(),
        debounceTime(250),
      )
      .subscribe(() => {
        this.fixColumns();
      });
  }

  public trackByName(_index:number, elem:{ name:string }) {
    return elem.name;
  }

  /**
   * Hide read-only fields, but only when in the create mode
   * @param {FieldDescriptor} field
   */
  public shouldHideField(descriptor:FieldDescriptor) {
    const field = descriptor.field || descriptor.fields![0];
    return this.wpEditForm.editMode && !field.writable;
  }

  public fieldName(name:string) {
    if (name === 'startDate') {
      return 'combinedDate';
    }
    return name;
  }

  /**
   * Fix the top of the columns after view has been loaded
   * to prevent columns from repositioning (e.g. when editing multi-select fields)
   */
  private fixColumns() {
    let lastOffset = 0;
    // Find corresponding HTML of attribute fields for each group
    const htmlAttributes = jQuery(`div.attributes-group:contains(${this.group.name})`).find('.attributes-key-value');

    htmlAttributes.each(function () {
      const offset = jQuery(this).position().top;

      if (offset < lastOffset) {
        // Fix position of the column start
        jQuery(this).addClass('-column-start');
      }
      lastOffset = offset;
    });
  }
}
