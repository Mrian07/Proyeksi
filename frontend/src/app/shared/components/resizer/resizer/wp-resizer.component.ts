

import {
  AfterViewInit, ChangeDetectionStrategy, Component, ElementRef, Input, OnInit,
} from '@angular/core';
import { debounceTime, distinctUntilChanged } from 'rxjs/operators';
import { TransitionService } from '@uirouter/core';
import { BrowserDetector } from 'core-app/core/browser/browser-detector.service';
import { UntilDestroyedMixin } from 'core-app/shared/helpers/angular/until-destroyed.mixin';
import { ResizeDelta } from 'core-app/shared/components/resizer/resizer.component';
import { fromEvent } from 'rxjs';
import { MainMenuToggleService } from 'core-app/core/main-menu/main-menu-toggle.service';

@Component({
  selector: 'wp-resizer',
  template: `
    <resizer [customHandler]="false"
             [resizerClass]="resizerClass"
             cursorClass="col-resize"
             (end)="resizeEnd()"
             (start)="resizeStart()"
             (move)="resizeMove($event)">
    </resizer>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})

export class WpResizerDirective extends UntilDestroyedMixin implements OnInit, AfterViewInit {
  @Input() elementClass:string;

  @Input() resizeEvent:string;

  @Input() localStorageKey:string;

  @Input() resizeStyle:'flexBasis'|'width' = 'flexBasis';

  private resizingElement:HTMLElement;

  private elementWidth:number;

  private element:HTMLElement;

  private resizer:HTMLElement;

  // Min-width this element is allowed to have
  private elementMinWidth = 530;

  public moving = false;

  public resizerClass = 'work-packages--resizer icon-resizer-vertical-lines';

  constructor(readonly toggleService:MainMenuToggleService,
    private elementRef:ElementRef,
    readonly $transitions:TransitionService,
    readonly browserDetector:BrowserDetector) {
    super();
  }

  ngOnInit() {
    // Get element
    this.resizingElement = <HTMLElement>document.getElementsByClassName(this.elementClass)[0];

    // Get initial width from local storage and apply
    const localStorageValue = this.parseLocalStorageValue();
    this.elementWidth = localStorageValue
                        || (this.resizingElement.offsetWidth < this.elementMinWidth
                          ? this.elementMinWidth
                          : this.resizingElement.offsetWidth);

    // This case only happens when the timeline is loaded but not displayed.
    // Therefor the flexbasis will be set to 50%, just in px
    if (this.elementWidth === 0 && this.resizingElement.parentElement) {
      this.elementWidth = this.resizingElement.parentElement.offsetWidth / 2;
    }

    this.resizingElement.style[this.resizeStyle] = `${this.elementWidth}px`;

    // Add event listener
    this.element = this.elementRef.nativeElement;

    // Listen on sidebar changes and toggle column layout, if necessary
    this.toggleService.changeData$
      .pipe(
        distinctUntilChanged(),
        this.untilDestroyed(),
        debounceTime(100),
      )
      .subscribe(() => {
        this.applyColumnLayout();
      });

    // Listen to event
    fromEvent(window, 'resize', { passive: true })
      .pipe(
        this.untilDestroyed(),
        debounceTime(250),
      )
      .subscribe(() => this.applyColumnLayout());
  }

  ngAfterViewInit():void {
    // Get the reziser
    this.resizer = <HTMLElement> this.elementRef.nativeElement.getElementsByClassName(this.resizerClass)[0];

    this.applyColumnLayout();
  }

  ngOnDestroy() {
    super.ngOnDestroy();
    // Reset the style when killing this directive, otherwise the style remains
    this.resizingElement.style[this.resizeStyle] = '';
  }

  resizeStart() {
    // In case we dragged the resizer farther than the element can actually grow,
    // we reset it to the actual width at the start of the new resizing
    const localStorageValue = this.parseLocalStorageValue();
    const actualElementWidth = this.resizingElement.offsetWidth;
    if (localStorageValue && localStorageValue > actualElementWidth) {
      this.elementWidth = actualElementWidth;
    }
  }

  resizeEnd() {
    const localStorageValue = this.parseLocalStorageValue();
    if (localStorageValue) {
      this.elementWidth = localStorageValue;
    }

    // Send a event that we resized this element
    const event = new Event(this.resizeEvent);
    window.dispatchEvent(event);

    this.manageErrorClass(false);
  }

  resizeMove(deltas:ResizeDelta) {
    // Get new value depending on the delta
    this.elementWidth -= deltas.relative.x;
    let newValue;

    // The resizingElement is not allowed to be smaller than the elementMinWidth
    if (this.elementWidth < this.elementMinWidth) {
      newValue = this.elementMinWidth;

      // Show the resizer red when it reaches its limit (min-width)
      this.manageErrorClass(true);
    } else {
      newValue = this.elementWidth;

      this.manageErrorClass(false);
    }

    // Store item in local storage
    window.ProyeksiApp.guardedLocalStorage(this.localStorageKey, `${newValue}`);

    // Apply two column layout
    this.applyColumnLayout();

    // Set new width
    this.resizingElement.style[this.resizeStyle] = `${newValue}px`;
  }

  private parseLocalStorageValue():number|undefined {
    const localStorageValue = window.ProyeksiApp.guardedLocalStorage(this.localStorageKey);
    const number = parseInt(localStorageValue || '', 10);

    if (typeof number === 'number' && number !== NaN) {
      return number;
    }

    return undefined;
  }
  private applyColumnLayout(checkWidth = 750) {
    const singleView = document.querySelectorAll("[data-selector='wp-single-view']")[0] as HTMLElement;
    if (singleView) {
      jQuery(singleView).toggleClass('work-package--single-view_with-columns', singleView.offsetWidth > checkWidth);
    }
  }

  private manageErrorClass(shouldBePresent:boolean) {
    if (shouldBePresent && !this.resizer.classList.contains('-error-font')) {
      this.resizer.classList.add('-error-font');
    }

    if (!shouldBePresent && this.resizer.classList.contains('-error-font')) {
      this.resizer.classList.remove('-error-font');
    }
  }
}
