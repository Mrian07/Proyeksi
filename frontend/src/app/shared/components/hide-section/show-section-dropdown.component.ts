

import { Component, ElementRef, OnInit } from '@angular/core';
import { HideSectionService } from './hide-section.service';

export const showSectionDropdownSelector = 'show-section-dropdown';

@Component({
  selector: showSectionDropdownSelector,
  template: '',
})
export class ShowSectionDropdownComponent implements OnInit {
  public optValue:string; // value of option for which hide-section should be visible

  public hideSecWithName:string; // section-name of hide-section

  constructor(private HideSection:HideSectionService,
    private elementRef:ElementRef) {
  }

  ngOnInit() {
    const element = jQuery(this.elementRef.nativeElement);
    this.optValue = element.data('optValue');
    this.hideSecWithName = element.data('hideSecWithName');

    const target = jQuery(this.elementRef.nativeElement).prev();
    target.on('change', (event) => {
      const selectedOption = jQuery('option:selected', event.target);

      if (selectedOption.val() !== this.optValue) {
        this.HideSection.hide(this.hideSecWithName);
      } else {
        this.HideSection.show(this.hideSecWithName);
      }
    });
  }
}
