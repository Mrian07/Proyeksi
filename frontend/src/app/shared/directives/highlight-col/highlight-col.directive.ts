

import {
  Component, ElementRef, OnDestroy, OnInit,
} from '@angular/core';

export const highlightColSelector = 'col[opHighlightCol]';

@Component({
  selector: highlightColSelector,
  template: '',
})
export class OpHighlightColDirective implements OnInit, OnDestroy { // eslint-disable-line @angular-eslint/component-class-suffix
  private $element:JQuery;

  private thead:JQuery;

  constructor(private elementRef:ElementRef) {
  }

  ngOnInit() {
    this.$element = jQuery(this.elementRef.nativeElement);
    this.thead = this.$element
      .parent('colgroup')
      .siblings('thead');

    // Separate handling instead of toggle is necessary to avoid
    // unwanted side effects when adding/removing columns via keyboard in the modal
    this.thead.on('mouseenter', 'th', (evt:JQuery.TriggeredEvent) => {
      if (this.$element.index() === jQuery(evt.currentTarget).index()) {
        this.$element.addClass('hover');
      }
    });

    this.thead.on('mouseleave', 'th', (evt:JQuery.TriggeredEvent) => {
      if (this.$element.index() === jQuery(evt.currentTarget).index()) {
        this.$element.removeClass('hover');
      }
    });
  }

  ngOnDestroy() {
    this.thead.off('mouseenter mouseleave');
  }
}
