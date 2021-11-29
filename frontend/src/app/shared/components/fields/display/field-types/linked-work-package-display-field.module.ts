

import { StateService } from '@uirouter/core';
import { KeepTabService } from 'core-app/features/work-packages/components/wp-single-view-tabs/keep-tab/keep-tab.service';
import { UiStateLinkBuilder } from 'core-app/features/work-packages/components/wp-fast-table/builders/ui-state-link-builder';
import { WorkPackageDisplayField } from 'core-app/shared/components/fields/display/field-types/work-package-display-field.module';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';

export class LinkedWorkPackageDisplayField extends WorkPackageDisplayField {
  public text = {
    linkTitle: this.I18n.t('js.work_packages.message_successful_show_in_fullscreen'),
    none: this.I18n.t('js.filter.noneElement'),
  };

  @InjectField() $state!:StateService;

  @InjectField() keepTab!:KeepTabService;

  private uiStateBuilder:UiStateLinkBuilder = new UiStateLinkBuilder(this.$state, this.keepTab);

  public render(element:HTMLElement, displayText:string):void {
    if (this.isEmpty()) {
      element.innerText = this.placeholder;
      return;
    }

    const link = this.uiStateBuilder.linkToShow(
      this.wpId,
      this.text.linkTitle,
      this.valueString,
    );

    const title = document.createElement('span');
    title.textContent = ` ${_.truncate(this.title, { length: 40 })}`;

    element.innerHTML = '';
    element.appendChild(link);
    element.appendChild(title);
  }

  public get writable():boolean {
    return false;
  }

  public get valueString() {
    return `#${this.wpId}`;
  }
}
