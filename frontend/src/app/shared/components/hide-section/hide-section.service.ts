

import { GonService } from 'core-app/core/gon/gon.service';
import { Injectable } from '@angular/core';
import { input } from 'reactivestates';

export interface HideSectionDefinition {
  key:string;
  label:string;
}

@Injectable({ providedIn: 'root' })
export class HideSectionService {
  public displayed = input<string[]>();

  public all:HideSectionDefinition[] = [];

  constructor(Gon:GonService) {
    const sections:any = Gon.get('hideSections');
    this.all = sections.all;
    this.displayed.putValue(sections.active.map((el:HideSectionDefinition) => {
      this.toggleVisibility(el.key, true);
      return el.key;
    }));

    this.removeHiddenOnSubmit();
  }

  section(key:string):HTMLElement|null {
    return document.querySelector(`section.hide-section[data-section-name="${key}"]`);
  }

  hide(key:string) {
    this.displayed.doModify((displayed) => displayed.filter((el) => el !== key));
    this.toggleVisibility(key, false);
  }

  show(key:string) {
    this.displayed.doModify((displayed) => [...displayed, key]);
    this.toggleVisibility(key, true);
  }

  private toggleVisibility(key:string, visible:boolean) {
    const section = this.section(key);

    if (section) {
      section.hidden = !visible;
    }
  }

  private removeHiddenOnSubmit() {
    jQuery(document.body)
      .on('submit', 'form', function (evt:any) {
        const form = jQuery(this);
        const sections = form.find('section.hide-section:hidden');

        if (form.data('hideSectionRemoved') || sections.length === 0) {
          return true;
        }

        form.data('hideSectionRemoved', true);
        sections.remove();
        form.trigger('submit');
        evt.preventDefault();
        return false;
      });
  }
}
