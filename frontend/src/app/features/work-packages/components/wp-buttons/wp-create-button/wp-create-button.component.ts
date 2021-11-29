

import { StateService, TransitionService } from '@uirouter/core';
import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, OnDestroy, OnInit,
} from '@angular/core';
import { I18nService } from 'core-app/core/i18n/i18n.service';
import { AuthorisationService } from 'core-app/core/model-auth/model-auth.service';
import { Observable } from 'rxjs';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { componentDestroyed } from '@w11k/ngx-componentdestroyed';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';

@Component({
  selector: 'wp-create-button',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './wp-create-button.html',
})
export class WorkPackageCreateButtonComponent extends UntilDestroyedMixin implements OnInit, OnDestroy {
  @Input('allowed') allowedWhen:string[];

  @Input('stateName$') stateName$:Observable<string>;

  allowed:boolean;

  disabled:boolean;

  projectIdentifier:string|null;

  types:any;

  transitionUnregisterFn:Function;

  text = {
    createWithDropdown: this.I18n.t('js.work_packages.create.button'),
    createButton: this.I18n.t('js.label_work_package'),
    explanation: this.I18n.t('js.label_create_work_package'),
  };

  constructor(readonly $state:StateService,
    readonly currentProject:CurrentProjectService,
    readonly authorisationService:AuthorisationService,
    readonly transition:TransitionService,
    readonly I18n:I18nService,
    readonly cdRef:ChangeDetectorRef) {
    super();
  }

  ngOnInit() {
    this.projectIdentifier = this.currentProject.identifier;

    // Find the first permission that is allowed
    this.authorisationService
      .observeUntil(componentDestroyed(this))
      .subscribe(() => {
        this.allowed = !!this
          .allowedWhen
          .find((combined) => {
            const [module, permission] = combined.split('.');
            return this.authorisationService.can(module, permission);
          });

        this.updateDisabledState();
      });

    this.transitionUnregisterFn = this.transition.onSuccess({}, this.updateDisabledState.bind(this));
  }

  ngOnDestroy():void {
    super.ngOnDestroy();
    this.transitionUnregisterFn();
  }

  private updateDisabledState() {
    this.disabled = !this.allowed || this.$state.includes('**.new');
    this.cdRef.detectChanges();
  }
}
