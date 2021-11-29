

import { Injectable } from "@angular/core";

@Injectable()
export class CostSubformAugmentService {

  constructor() {
    jQuery('costs-subform').each((i, match) => {
      const el = jQuery(match);

      const container = el.find('.subform-container');

      const templateEl = el.find('.subform-row-template');
      templateEl.detach();
      const template = templateEl[0].outerHTML;
      let rowIndex = parseInt(el.attr('item-count')!);

      el.on('click', '.delete-row-button,.delete-budget-item', (evt:any) => {
        jQuery(evt.target).closest('.subform-row').remove();
        return false;
      });

      // Add new row handler
      el.find('.add-row-button,.wp-inline-create--add-link').click((evt:any) => {
        evt.preventDefault();
        const row = jQuery(template.replace(/INDEX/g, rowIndex.toString()));
        row.show();
        row.removeClass('subform-row-template');
        row.find('input.costs-date-picker').prop('required', true);
        row.find('input[id^="cost_type_new_rate_attributes"]').prop('required', true);

        container.append(row);
        rowIndex += 1;

        container.find('.subform-row:last-child input:first').focus();

        return false;
      });
    });
  }
}


