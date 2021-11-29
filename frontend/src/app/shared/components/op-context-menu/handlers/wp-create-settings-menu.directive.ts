

import { OPContextMenuService } from 'core-app/shared/components/op-context-menu/op-context-menu.service';
import { Directive, ElementRef } from '@angular/core';
import { OpContextMenuTrigger } from 'core-app/shared/components/op-context-menu/handlers/op-context-menu-trigger.directive';
import { HalResourceEditingService } from 'core-app/shared/components/fields/edit/services/hal-resource-editing.service';
import { States } from 'core-app/core/states/states.service';
import { FormResource } from 'core-app/features/hal/resources/form-resource';

@Directive({
  selector: '[wpCreateSettingsMenu]',
})
export class WorkPackageCreateSettingsMenuDirective extends OpContextMenuTrigger {
  constructor(readonly elementRef:ElementRef,
    readonly opContextMenu:OPContextMenuService,
    readonly states:States,
    readonly halEditing:HalResourceEditingService) {
    super(elementRef, opContextMenu);
  }

  protected open(evt:JQuery.TriggeredEvent) {
    const wp = this.states.workPackages.get('new').value;

    if (wp) {
      const change = this.halEditing.changeFor(wp);
      change.getForm().then(
        (loadedForm:FormResource) => {
          this.buildItems(loadedForm);
          this.opContextMenu.show(this, evt);
        },
      );
    }
  }

  /**
   * Positioning args for jquery-ui position.
   *
   * @param {Event} openerEvent
   */
  public positionArgs(evt:JQuery.TriggeredEvent) {
    const additionalPositionArgs = {
      my: 'right top',
      at: 'right bottom',
    };

    const position = super.positionArgs(evt);
    _.assign(position, additionalPositionArgs);

    return position;
  }

  private buildItems(form:FormResource) {
    this.items = [];
    const configureFormLink = form.configureForm;
    const queryCustomFields = form.customFields;

    if (queryCustomFields) {
      this.items.push({
        href: queryCustomFields.href,
        icon: 'icon-custom-fields',
        linkText: queryCustomFields.name,
        onClick: () => false,
      });
    }

    if (configureFormLink) {
      this.items.push({
        href: configureFormLink.href,
        icon: 'icon-settings3',
        linkText: configureFormLink.name,
        onClick: () => false,
      });
    }
  }
}
