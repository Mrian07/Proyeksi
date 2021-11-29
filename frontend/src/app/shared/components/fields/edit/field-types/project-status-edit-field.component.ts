

import { I18nService } from 'core-app/core/i18n/i18n.service';
import { Component, OnInit, ViewChild } from '@angular/core';
import { EditFieldComponent } from 'core-app/shared/components/fields/edit/edit-field.component';
import { NgSelectComponent } from '@ng-select/ng-select';
import {
  projectStatusCodeCssClass,
  projectStatusI18n,
} from 'core-app/shared/components/fields/helpers/project-status-helper';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { HalResource } from 'core-app/features/hal/resources/hal-resource';

interface ProjectStatusOption {
  href:string
  name:string
  colorClass:string
}

@Component({
  templateUrl: './project-status-edit-field.component.html',
  styleUrls: ['./project-status-edit-field.component.sass'],
})
export class ProjectStatusEditFieldComponent extends EditFieldComponent implements OnInit {
  @ViewChild(NgSelectComponent, { static: true }) public ngSelectComponent:NgSelectComponent;

  @InjectField() I18n!:I18nService;

  public availableStatuses:ProjectStatusOption[] = [{
    href: 'not_set',
    name: projectStatusI18n('not_set', this.I18n),
    colorClass: projectStatusCodeCssClass('not_set'),
  }];

  public currentStatusCode:string;

  public hiddenOverflowContainer = '#content-wrapper';

  public appendToContainer = 'body';

  ngOnInit() {
    this.currentStatusCode = this.resource.status === null ? this.availableStatuses[0].href : this.resource.status.href;

    this.change.getForm().then((form) => {
      form.schema.status.allowedValues.forEach((status:HalResource) => {
        this.availableStatuses = [...this.availableStatuses,
          {
            href: status.href!,
            name: status.name,
            colorClass: projectStatusCodeCssClass(status.id),
          }];
      });

      // The timeout takes care that the opening is added to the end of the current call stack.
      // Thus we can be sure that the select box is rendered and ready to be opened.
      const that = this;
      window.setTimeout(() => {
        that.ngSelectComponent.open();
      }, 0);
    });
  }

  public onChange() {
    this.resource.status = this.currentStatusCode === this.availableStatuses[0].href ? null : { href: this.currentStatusCode };
    this.handler.handleUserSubmit();
  }

  public onOpen() {
    // Force reposition as a workaround for BUG
    // https://github.com/ng-select/ng-select/issues/1259
    setTimeout(() => {
      const component = (this.ngSelectComponent) as any;
      if (component && component.dropdownPanel) {
        component.dropdownPanel._updatePosition();
      }

      jQuery(this.hiddenOverflowContainer).one('scroll.autocompleteContainer', () => {
        this.ngSelectComponent.close();
      });
    }, 25);
  }

  public onClose() {
    jQuery(this.hiddenOverflowContainer).off('scroll.autocompleteContainer');
  }
}
