

import { KeepTabService } from 'core-app/features/work-packages/components/wp-single-view-tabs/keep-tab/keep-tab.service';
import { StateService } from '@uirouter/core';
import { UiStateLinkBuilder } from 'core-app/features/work-packages/components/wp-fast-table/builders/ui-state-link-builder';
import { IdDisplayField } from 'core-app/shared/components/fields/display/field-types/id-display-field.module';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';

export class WorkPackageIdDisplayField extends IdDisplayField {
  @InjectField() $state!:StateService;

  @InjectField() keepTab!:KeepTabService;

  private uiStateBuilder:UiStateLinkBuilder = new UiStateLinkBuilder(this.$state, this.keepTab);

  public render(element:HTMLElement, displayText:string):void {
    if (!this.value) {
      return;
    }
    const link = this.uiStateBuilder.linkToShow(
      this.value,
      displayText,
      this.value,
    );

    element.appendChild(link);
  }
}
