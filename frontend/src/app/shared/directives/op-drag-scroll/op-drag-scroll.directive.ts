
import { Directive, ElementRef, OnInit } from '@angular/core';

@Directive({
  selector: 'op-drag-scroll',
})
export class OpDragScrollDirective implements OnInit {
  constructor(readonly elementRef:ElementRef) {
  }

  ngOnInit() {
    const element = jQuery(this.elementRef.nativeElement);
    const eventName = 'op:dragscroll';

    // Is mouse down?
    let mousedown = false;

    // Position of last mousedown
    let mousedownX:number; let
      mousedownY:number;

    // Mousedown: Potential drag start
    element.on('mousedown', (evt) => {
      setTimeout(() => {
        mousedown = true;
        mousedownX = evt.clientX;
        mousedownY = evt.clientY;
      }, 50, false);
    });

    // Mouseup: Potential drag stop
    element.on('mouseup', () => {
      mousedown = false;
    });

    // Mousemove: Report movement if mousedown
    element.on('mousemove', (evt) => {
      if (!mousedown) {
        return;
      }

      // Trigger drag scroll event
      element.trigger(eventName, {
        x: evt.clientX - mousedownX,
        y: evt.clientY - mousedownY,
      });

      // Update last mouse position
      mousedownX = evt.clientX;
      mousedownY = evt.clientY;
    });
  }
}
