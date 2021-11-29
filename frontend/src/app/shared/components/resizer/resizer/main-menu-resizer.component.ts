

import {
  ChangeDetectorRef, Component, ElementRef, OnInit,
} from '@angular/core';
import { distinctUntilChanged } from 'rxjs/operators';
import { ResizeDelta } from 'core-app/shared/components/resizer/resizer.component';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { MainMenuToggleService } from 'core-app/core/main-menu/main-menu-toggle.service';

export const mainMenuResizerSelector = 'main-menu-resizer';

@Component({
  selector: mainMenuResizerSelector,
  template: `
    <resizer class="main-menu--resizer"
             [customHandler]="true"
             [cursorClass]="'col-resize'"
             (end)="resizeEnd()"
             (start)="resizeStart()"
             (move)="resizeMove($event)">
      <div class="resizer-toggle-container">
        <button
          class="op-link main-menu--navigation-toggler"
          [attr.title]="toggleTitle"
          [class.open]="toggleService.showNavigation"
          (click)="toggleService.toggleNavigation($event)">
          <op-icon icon-classes="icon-resizer-vertical-lines"></op-icon>
        </button>
      </div>
    </resizer>
  `,
})

export class MainMenuResizerComponent extends UntilDestroyedMixin implements OnInit {
  public toggleTitle:string;

  private resizeEvent:string;

  private localStorageKey:string;

  private elementWidth:number;

  private mainMenu = jQuery('#main-menu')[0];

  public moving = false;

  constructor(readonly toggleService:MainMenuToggleService,
    readonly cdRef:ChangeDetectorRef,
    readonly elementRef:ElementRef) {
    super();
  }

  ngOnInit() {
    this.toggleService.titleData$
      .pipe(
        distinctUntilChanged(),
        this.untilDestroyed(),
      )
      .subscribe((setToggleTitle) => {
        this.toggleTitle = setToggleTitle;
        this.cdRef.detectChanges();
      });

    this.resizeEvent = 'main-menu-resize';
    this.localStorageKey = 'openProject-mainMenuWidth';
  }

  public resizeStart() {
    this.elementWidth = this.mainMenu.clientWidth;
  }

  public resizeMove(deltas:ResizeDelta) {
    this.toggleService.saveWidth(this.elementWidth + deltas.absolute.x);
  }

  public resizeEnd() {
    const event = new Event(this.resizeEvent);
    window.dispatchEvent(event);
  }
}
