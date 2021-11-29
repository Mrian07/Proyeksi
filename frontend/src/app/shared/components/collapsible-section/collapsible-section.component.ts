

import {
  Component, ElementRef, OnInit, ViewChild,
} from '@angular/core';

export const collapsibleSectionAugmentSelector = 'collapsible-section-augment';

@Component({
  selector: collapsibleSectionAugmentSelector,
  templateUrl: './collapsible-section.html',
})
export class CollapsibleSectionComponent implements OnInit {
  public expanded = false;

  public sectionTitle:string;

  @ViewChild('sectionBody', { static: true }) public sectionBody:ElementRef;

  constructor(public elementRef:ElementRef) {
  }

  ngOnInit():void {
    const element:HTMLElement = this.elementRef.nativeElement;

    this.sectionTitle = element.getAttribute('section-title')!;
    if (element.getAttribute('initially-expanded') === 'true') {
      this.expanded = true;
    }

    const target:HTMLElement = element.nextElementSibling as HTMLElement;
    this.sectionBody.nativeElement.appendChild(target);
    target.removeAttribute('hidden');
  }

  public toggle(event:Event) {
    this.expanded = !this.expanded;
    event.preventDefault();
  }
}
