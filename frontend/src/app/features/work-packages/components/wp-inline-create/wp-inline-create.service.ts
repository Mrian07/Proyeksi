

import { Injectable, Injector, OnDestroy } from '@angular/core';
import { WorkPackageResource } from 'core-app/features/hal/resources/work-package-resource';
import { Subject } from 'rxjs';
import { ComponentType } from '@angular/cdk/portal';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { AuthorisationService } from 'core-app/core/model-auth/model-auth.service';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';

@Injectable()
export class WorkPackageInlineCreateService implements OnDestroy {
  @InjectField() I18n!:I18nService;

  @InjectField() protected readonly authorisationService:AuthorisationService;

  constructor(readonly injector:Injector) {
  }

  /**
   * A separate reference pane for the inline create component
   */
  public readonly referenceComponentClass:ComponentType<any>|null = null;

  /**
   * A related work package for the inline create context
   */
  public referenceTarget:WorkPackageResource|null = null;

  /**
   * Reference button text
   */
  public readonly buttonTexts = {
    reference: '',
    create: this.I18n.t('js.label_create_work_package'),
  };

  public get canAdd() {
    return this.canCreateWorkPackages || this.authorisationService.can('work_package', 'addChild');
  }

  public get canReference() {
    return false;
  }

  public get canCreateWorkPackages() {
    return this.authorisationService.can('work_packages', 'createWorkPackage')
      && this.authorisationService.can('work_packages', 'editWorkPackage');
  }

  /** Allow callbacks to happen on newly created inline work packages */
  public newInlineWorkPackageCreated = new Subject<string>();

  /** Allow callbacks to happen on newly created inline work packages */
  public newInlineWorkPackageReferenced = new Subject<string>();

  /**
   * Ensure hierarchical injected versions of this service correctly unregister
   */
  ngOnDestroy() {
    this.newInlineWorkPackageCreated.complete();
    this.newInlineWorkPackageReferenced.complete();
  }
}
