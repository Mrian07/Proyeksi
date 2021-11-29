

import {
  Component, Input, EventEmitter, Output,
} from '@angular/core';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { WorkPackageRelationsHierarchyService } from 'core-app/features/work-packages/components/wp-relations/wp-relations-hierarchy/wp-relations-hierarchy.service';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { WorkPackageNotificationService } from 'core-app/features/work-packages/services/notifications/work-package-notification.service';

@Component({
  templateUrl: './wp-breadcrumb-parent.html',
  selector: 'wp-breadcrumb-parent',
})
export class WorkPackageBreadcrumbParentComponent {
  @Input('workPackage') workPackage:WorkPackageResource;

  @Output('onSwitch') onSwitch = new EventEmitter<boolean>();

  public isSaving = false;

  public text = {
    edit_parent: this.I18n.t('js.relation_buttons.change_parent'),
    set_or_remove_parent: this.I18n.t('js.relations_autocomplete.parent_placeholder'),
    remove_parent: this.I18n.t('js.relation_buttons.remove_parent'),
    set_parent: this.I18n.t('js.relation_buttons.set_parent'),
  };

  private editing:boolean;

  public constructor(
    protected readonly I18n:I18nService,
    protected readonly wpRelationsHierarchy:WorkPackageRelationsHierarchyService,
    protected readonly notificationService:WorkPackageNotificationService,
  ) {
  }

  public canModifyParent():boolean {
    return !!this.workPackage.changeParent;
  }

  public get parent() {
    return this.workPackage && this.workPackage.parent;
  }

  public get active():boolean {
    return this.editing;
  }

  public close():void {
    this.toggle(false);
  }

  public open():void {
    this.toggle(true);
  }

  public updateParent(newParent:WorkPackageResource|null) {
    this.close();
    const newParentId = newParent ? newParent.id : null;
    if (_.get(this.parent, 'id', null) === newParentId) {
      return;
    }

    this.isSaving = true;
    this.wpRelationsHierarchy.changeParent(this.workPackage, newParentId)
      .catch((error:any) => {
        this.notificationService.handleRawError(error, this.workPackage);
      })
      .then(() => this.isSaving = false); // Behaves as .finally()
  }

  private toggle(state:boolean) {
    if (this.editing !== state) {
      this.editing = state;
      this.onSwitch.emit(this.editing);
    }
  }
}
