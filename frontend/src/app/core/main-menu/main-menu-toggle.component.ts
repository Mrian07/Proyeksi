

import {
  ChangeDetectionStrategy, ChangeDetectorRef, Component, Injector, OnInit,
} from '@angular/core';
import { distinctUntilChanged } from 'rxjs/operators';
import { CurrentProjectService } from 'core-app/core/current-project/current-project.service';
import { DeviceService } from 'core-app/core/browser/device.service';
import { InjectField } from 'core-app/shared/helpers/angular/inject-field.decorator';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { MainMenuToggleService } from './main-menu-toggle.service';

export const mainMenuToggleSelector = 'main-menu-toggle';

@Component({
  selector: mainMenuToggleSelector,
  changeDetection: ChangeDetectionStrategy.OnPush,
  host: {
    class: 'op-app-menu op-main-menu-toggle',
  },
  template: `
    <button
      *ngIf="this.currentProject.id !== null || this.deviceService.isMobile"
      class="op-app-menu--item-action"
      id="main-menu-toggle"
      aria-haspopup="true"
      type="button"
      [attr.title]="toggleTitle"
      (click)="toggleService.toggleNavigation($event)"
    >
      <op-icon class="icon-hamburger" aria-hidden="true"></op-icon>
      <op-icon class="icon-close" aria-hidden="true"></op-icon>
    </button>
  `,
})

export class MainMenuToggleComponent extends UntilDestroyedMixin implements OnInit {
  toggleTitle = '';

  @InjectField() currentProject:CurrentProjectService;

  constructor(readonly toggleService:MainMenuToggleService,
    readonly cdRef:ChangeDetectorRef,
    readonly deviceService:DeviceService,
    readonly injector:Injector) {
    super();
  }

  ngOnInit() {
    this.toggleService.initializeMenu();

    this.toggleService.titleData$
      .pipe(
        distinctUntilChanged(),
        this.untilDestroyed(),
      )
      .subscribe((setToggleTitle) => {
        this.toggleTitle = setToggleTitle;
        this.cdRef.detectChanges();
      });
  }
}
